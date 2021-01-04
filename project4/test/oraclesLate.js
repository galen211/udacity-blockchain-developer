var Test = require("../config/testConfig.js");
const { expect } = require("chai");

const {
  BN, // Big Number support
  constants, // Common constants, like the zero address and largest integers
  expectEvent, // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
  balance,
  ether,
} = require("@openzeppelin/test-helpers");

contract("Oracle Functionality", async (accounts) => {
  // Watch contract events
  const STATUS_CODE_UNKNOWN = 0;
  const STATUS_CODE_ON_TIME = 10;
  const STATUS_CODE_LATE_AIRLINE = 20;
  const STATUS_CODE_LATE_WEATHER = 30;
  const STATUS_CODE_LATE_TECHNICAL = 40;
  const STATUS_CODE_LATE_OTHER = 50;

  let config;
  let app;
  let actors;
  let actorNames;
  let oracles;
  let oracleRegistrationFee;

  let MIN_ORACLE_RESPONSES;

  before("Setup contract variables and register flight", async () => {
    config = await Test.Config(accounts);
    app = config.flightSuretyApp;
    actors = config.actors;
    actorNames = config.actorNames;
    oracles = config.oracles;
    oracleRegistrationFee = ether("1");
    MIN_ORACLE_RESPONSES = 3;
  });

  describe("Scenario: On time flight", () => {
    let airlineFundingAmount;
    let insuranceAmount;

    let flightName;
    let departureTime;
    let flightAirline;
    let passengerAddress;

    let reportedFlightStatus;

    before("Setup scenario variables", () => {
      airlineFundingAmount = ether("10");
      insuranceAmount = ether("1");
      flightName = "NH278";
      departureTime = "1609623567158";
      flightAirline = actors.airline1;
      passengerAddress = actors.passenger1;
      reportedFlightStatus = STATUS_CODE_LATE_AIRLINE;

      // printing for debug
      console.log("-----------------------");
      console.log("Passenger address: " + passengerAddress);
      console.log("Flight Airline: " + flightAirline);
      console.log("Flight Name:    " + flightName);
      console.log("Departure Time: " + departureTime);

      let counter = 1;
      oracles.forEach((oracleAccount) => {
        console.log("Oracle Account " + counter++ + ": " + oracleAccount);
      });
      console.log("-----------------------");

      console.log("LOG: Setup complete");
    });

    it("Register oracles", async () => {
      oracles.forEach(async (oracleAccount) => {
        let tx = await app.registerOracle({
          from: oracleAccount,
          value: oracleRegistrationFee,
        });
        let result = await app.getMyIndexes.call({ from: oracleAccount });
        expectEvent(tx, "OracleRegistered", {
          oracleAddress: oracleAccount,
          indexes: result,
        });

        expect(await app.isOracleRegistered.call(oracleAccount)).to.be.true;
      });
      console.log("LOG: Register oracles complete");
    });

    it("Fund airline", async () => {
      expect(await app.isAirlineRegistered.call(flightAirline)).to.be.true;

      let tx0 = await app.fundAirline({
        from: flightAirline,
        value: airlineFundingAmount,
      });
      expectEvent(tx0, "AirlineFunded", {
        airlineAddress: flightAirline,
        amount: airlineFundingAmount,
      });

      expect(await app.isAirlineFunded.call(flightAirline)).to.be.true;
      console.log("LOG: Fund airline complete");
    });

    it("Register flight", async () => {
      let tx1 = await app.registerFlight(flightName, departureTime, {
        from: flightAirline,
      });
      expectEvent(tx1, "FlightRegistered", {
        airlineAddress: flightAirline,
        flight: flightName,
      });

      expect(
        await app.isFlightRegistered.call(
          flightAirline,
          flightName,
          departureTime
        )
      ).to.be.true;
      console.log("LOG: Register flight complete");
    });

    it("Purchase insurance", async () => {
      let tx2 = await app.buyFlightInsurance(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress, value: insuranceAmount }
      );
      expectEvent(tx2, "InsurancePurchased", {
        passengerAddress: passengerAddress,
        amount: insuranceAmount,
      });

      expect(
        await app.isPassengerInsured.call(
          passengerAddress,
          flightAirline,
          flightName,
          departureTime
        )
      ).to.be.true;
      console.log("LOG: Purchase insurance complete");
    });

    it("Check initial flight status", async () => {
      let status = await app.officialFlightStatus.call(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      expect(status.toNumber()).to.be.equal(STATUS_CODE_UNKNOWN);

      console.log("LOG: Check initial flight status complete");
    });

    it("Fetch flight status", async () => {
      expect(
        await app.isFlightRegistered.call(
          flightAirline,
          flightName,
          departureTime
        )
      ).to.be.true;

      expectEvent(
        await app.fetchFlightStatus(flightAirline, flightName, departureTime, {
          from: passengerAddress,
        }),
        "OracleRequest",
        {
          airline: flightAirline,
          flight: flightName,
          departureTime: departureTime,
        }
      );
      console.log("LOG: Fetch flight status complete");
    });

    it("Report flight status", async () => {
      let acceptedReports = 0;
      oracles.forEach(async (oracleAccount) => {
        expect(await app.isOracleRegistered.call(oracleAccount)).to.be.true;

        let oracleIndexes = await app.getMyIndexes.call({
          from: oracleAccount,
        });

        expect(oracleIndexes).to.have.lengthOf(3);

        for (let idx = 0; idx < 3; idx++) {
          let reportTx;
          try {
            reportTx = await app.submitOracleResponse(
              oracleIndexes[idx],
              flightAirline,
              flightName,
              departureTime,
              reportedFlightStatus,
              { from: oracleAccount }
            );

            // expectEvent(reportTx, "OracleReport", {
            //   airline: flightAirline,
            //   flight: flightName,
            //   departureTime: departureTime,
            //   status: reportedFlightStatus,
            // });

            acceptedReports++;
            // console.log(
            //   "Success",
            //   idx,
            //   oracleIndexes[idx].toNumber(),
            //   flightName
            // );
          } catch (e) {
            console.log(e);
            // console.log(
            //   "Error",
            //   idx,
            //   oracleIndexes[idx].toNumber(),
            //   flightName
            // );
            //expect(tx.message).to.include("Index does not match oracle request");
          }
        }
      });
      //   expect(acceptedReports).to.be.gte(MIN_ORACLE_RESPONSES);
      console.log("LOG: Report flight status complete");
    });

    it("Verify flight status is late due to airline", async () => {
      let status = await app.officialFlightStatus.call(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      expect(status.toNumber()).to.be.equal(reportedFlightStatus);
      console.log("LOG: Verify flight status complete");
    });

    it("Verify insurance payout", async () => {
      let isPaidOut = await app.isPaidOut(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      assert.equal(isPaidOut, false, "Insurance not paid out");

      let passengerBalance = await app.passengerBalance(passengerAddress);
      expect(passengerBalance).to.be.bignumber.equal(ether("1.5"));
      console.log("LOG: Verify insurance payout complete");
    });
  }); // describe
}); // contract
