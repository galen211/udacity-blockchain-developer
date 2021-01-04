var Test = require("../config/testConfig.js");
const testConfig = require("../config/testConfig.js");
const { expect } = require("chai");

const {
  BN, // Big Number support
  constants, // Common constants, like the zero address and largest integers
  expectEvent, // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
  balance,
  ether,
} = require("@openzeppelin/test-helpers");

contract("Fund Transfers", async (accounts) => {
  // Watch contract events
  const STATUS_CODE_UNKNOWN = 0;
  const STATUS_CODE_ON_TIME = 10;
  const STATUS_CODE_LATE_AIRLINE = 20;
  const STATUS_CODE_LATE_WEATHER = 30;
  const STATUS_CODE_LATE_TECHNICAL = 40;
  const STATUS_CODE_LATE_OTHER = 50;

  let config;
  let data;
  let app;
  let actors;
  let airlines;
  let passengers;
  let flights;
  let oracles;
  let actorNames;

  let flightName;
  let departureTime;
  let flightAirline;
  let passengerAddress;
  let airlineFundingAmount;
  let oracleRegistrationFee;
  let expectedInsurancePayout;

  before("setup contract", async () => {
    config = await Test.Config(accounts);
    data = config.flightSuretyData;
    app = config.flightSuretyApp;
    actors = config.actors;
    airlines = config.airlines;
    passengers = config.passengers;
    flights = config.flights;
    oracles = config.oracles;
    actorNames = config.actorNames;

    insuranceAmount = ether("1");
    airlineFundingAmount = ether("10");
    oracleRegistrationFee = ether("1");
    expectedInsurancePayout = ether("1.5");

    flightName = "NH 278";
    departureTime = new Date(2020, 11, 30, 18, 0, 0).valueOf().toString();
    flightAirline = actors.airline1;
    passengerAddress = actors.passenger1;
  });

  describe("Scenario: data contract transactions", () => {
    it("Data contract balances reflect airline funding transaction", async () => {
      let tracker = await balance.tracker(data.address, (unit = "wei"));

      let tx = await app.fundAirline({
        from: flightAirline,
        value: airlineFundingAmount,
      });
      expectEvent(tx, "AirlineFunded", {
        airlineAddress: flightAirline,
        airlineName: actorNames.get(flightAirline),
        amount: airlineFundingAmount,
      });

      let result = await app.amountAirlineFunds(actors.airline1);
      expect(result).to.be.bignumber.equal(airlineFundingAmount);

      expect(await tracker.delta()).to.be.bignumber.equal(airlineFundingAmount);
    });

    it("Data contract balances reflect passenger insurance purchase transaction", async () => {
      let tracker = await balance.tracker(data.address, (unit = "wei"));

      let tx1 = await app.registerFlight(flightName, departureTime, {
        from: flightAirline,
      });

      expectEvent(tx1, "FlightRegistered", {
        airlineAddress: flightAirline,
        airlineName: actorNames.get(flightAirline),
        flight: flightName,
      });

      expect(await app.isFlightRegistered.call(flightAirline, flightName, departureTime)).to.be.true;

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

      expect(await tracker.delta()).to.be.bignumber.equal(insuranceAmount);
    });

    it("Data contract balances reflect oracle registration", async () => {
      let tracker = await balance.tracker(data.address, (unit = "wei"));

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

        expect(await tracker.delta()).to.be.bignumber.equal(
          oracleRegistrationFee
        );
      });
    });

    it("Data contract balances reflect passenger payout", async () => {



      let tx = await app.fetchFlightStatus(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      expectEvent(tx, "OracleRequest", {
        airline: airlineAddress,
        flight: flightName,
        departureTime: departureTime,
      });

      let validResponses = 0;
      oracles.forEach(async (oracleAccount) => {
        let oracleIndexes = await app.getMyIndexes.call({
          from: oracleAccount,
        });

        expect(oracleIndexes).to.have.lengthOf(3);

        for (let idx = 0; idx < 3; idx++) {
          try {
            let tx = await app.submitOracleResponse(
              oracleIndexes[idx],
              flightAirline,
              flightName,
              departureTime,
              STATUS_CODE_LATE_AIRLINE,
              { from: oracleAccount }
            );
            validResponses++;
            if (validResponses >= MIN_RESPONSES) {
              expectEvent(tx, "FlightStatusInfo", {
                airline: flightAirline,
                flight: flightName,
                departureTime: departureTime,
                status: STATUS_CODE_LATE_AIRLINE,
              });

              expectEvent(tx, "InsurancePayout", {
                airlineAddres: flightAirline,
                flight: flightName,
              });
            }
          } catch (e) {
            continue;
          }
        }
      });
      expect(validResponses).to.be.gte(MIN_RESPONSES);

      let status = await app.officialFlightStatus.call(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      assert.equal(
        status.toNumber(),
        STATUS_CODE_LATE_AIRLINE,
        "Flight should be late due to airline"
      );

      let isPaidOut = await app.isPaidOut.call(
        flightAirline,
        flightName,
        departureTime,
        { from: passengerAddress }
      );
      assert.equal(isPaidOut, true, "Insurance should be paid out");

      // money transfer
      let contractTracker = await balance.tracker(data.address, (unit = "wei"));
      let passengerTracker = await balance.tracker(
        passengerAddress,
        (unit = "wei")
      );

      let passengerBalance = await app.passengerBalance(passengerAddress);
      expect(passengerBalance).to.be.bignumber.equal(expectedInsurancePayout);

      expect(await contractTracker.delta()).to.be.bignumber.equal(
        expectedInsurancePayout
      );
      expect(await passengerTracker.delta()).to.be.bignumber.equal(
        expectedInsurancePayout
      );

      passengerBalance = await app.passengerBalance(passengerAddress);
      expect(passengerBalance).to.be.bignumber.equal(ether("0"));
    });
  });
});
