var Test = require("../config/testConfig.js");
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

contract("Flight Surety Tests", async (accounts) => {
  var config;
  before("setup contract", async () => {
    config = await Test.Config(accounts);
    data = await config.flightSuretyData;
    app = await config.flightSuretyApp;
  });

  /****************************************************************************************/
  /* Operations and Settings                                                              */
  /****************************************************************************************/
  describe("Operations and Settings", () => {
    it(`Has correct initial isOperational() value`, async () => {
      let status = await data.isOperational();
      assert.equal(status, true, "Incorrect initial operating status value");
    });

    it(`Can block access to setOperatingStatus() for non-Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await data.setOperatingStatus(false, {
          from: config.actors.airline2,
        });
      } catch (e) {
        accessDenied = true;
      }
      assert.equal(
        accessDenied,
        true,
        "Access not restricted to Contract Owner"
      );
    });

    it(`Can allow access to setOperatingStatus() for Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await data.setOperatingStatus(false, { from: config.contractOwner });
      } catch (e) {
        accessDenied = true;
      }
      assert.equal(
        accessDenied,
        false,
        "Access not restricted to Contract Owner"
      );
    });

    it(`Can block access to functions using requireIsOperational when operating status is false`, async () => {
      await data.setOperatingStatus(false, {from: config.contractOwner});
      let reverted = false;
      try {
        await app.registerAirline(config.actors.airline2, {from: airline1});
      } catch (e) {
        reverted = true;
      }
      assert.equal(
        reverted,
        true,
        "Access not blocked for requireIsOperational"
      );
      // Set it back for other tests to work
      await data.setOperatingStatus(true, {from: config.contractOwner});
    });
  });

  /****************************************************************************************/
  /* Airline Business Logic                                                               */
  /****************************************************************************************/

  describe("Airline Business Logic", () => {

    it("First airline is registered when contract is deployed.", async () => {
      let tx = false;
      let threwError = false;
      try {
        tx = await app.isAirlineRegistered(config.actors.airline1);
      } catch (error) {
        threwError = true;
      }
      assert.equal(tx, true, "First airline is not registered upon deployment");
      assert.equal(threwError, false, "Test threw an unexpected error");
    });

    describe("Scenario: Only existing airline may register a new airline until there are at least four airlines registered", async () => {

      it("Unregistered airline cannot register a new airline", async () => {
        await expectRevert(
          app.registerAirline(config.actors.airline2, { from: config.actors.airline3 }),
          "Only a funded airline may register an airline or participate in consensus"
        );
      });

      it("Airline can be registered, but it cannot participate in contract until it submits funding of 10 ether", async () => {
        let currentDepositAmount = await data.amountAirlineFunds.call(config.actors.airline1);
        assert.equal(currentDepositAmount, 0, "Airline 1 should not be funded yet");

        await expectRevert(
          app.registerAirline(config.actors.airline2, { from: config.actors.airline1 }),
          "Only a funded airline may register an airline or participate in consensus"
        );

        let fundingAmount = web3.utils.toWei('10', 'ether'); // airline 1 submits funding

        let tx = await app.fundAirline({ from: config.actors.airline1 , value: fundingAmount })
        expectEvent(tx, 'AirlineFunded', {
          airlineAddress: config.actors.airline1,
          amount: fundingAmount
        });

        var amount = (await data.amountAirlineFunds.call(config.actors.airline1)).toString();
        assert.equal(amount, fundingAmount, "Expected 10 ether funding");
      });

      it("First airline registers the second airline.", async () => {
        let tx = await app.registerAirline(config.actors.airline2, { from: config.actors.airline1 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: config.actors.airline2
        });
      });

      it("Cannot re-register an airline that has already been registered", async () => {
        await expectRevert(
          app.registerAirline(config.actors.airline2, { from: config.actors.airline1 }),
          "Airline is already registered"
        );
      });

      it("Second airline registers the third airline.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: config.actors.airline2 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: config.actors.airline2,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(config.actors.airline3, { from: config.actors.airline2 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: config.actors.airline3
        });
      });

      it("Third airline registers the fourth airline.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: config.actors.airline3 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: config.actors.airline3,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(config.actors.airline4, { from: config.actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: config.actors.airline4
        });
      });
    });

    describe("Scenario: Registration of fifth and subsequent airlines requires multi-party consensus of 50% of registered airlines", async () => {

      it("Fourth airline cannot register the fifth without consensus.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: config.actors.airline4 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: config.actors.airline4,
          amount: fundingAmount
        });
        
        let tx = await app.registerAirline(config.actors.airline5, { from: config.actors.airline4 });
        expectEvent.notEmitted(tx, 'AirlineRegistered');
        
        let votes = await data.numberAirlineVotes.call(config.actors.airline5);
        assert.equal(votes, 1, "Expect only one vote has been cast for Airline #5");
      });

      it("Upon reaching 50% threshold of votes of all registered airlines, registration is successful", async () => {
        let tx = await app.registerAirline(config.actors.airline5, { from: config.actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: config.actors.airline5
        });
        let votes = await data.numberAirlineVotes.call(config.actors.airline5);
        assert.equal(votes, 2, "Expect two votes have been cast for Airline #5");
      });
    });
  });

  /****************************************************************************************/
  /* Passenger Business Logic                                                                                 */
  /****************************************************************************************/

  describe("Passenger Business Logic", async () => {
    let flight;
    let departureTime;
    let flightAirline;
    let passenger;
    let insuranceAmount;

    beforeEach(() => {
      flight = 'NH 278';
      departureTime = new Date(2020, 11, 30, 18, 0, 0).valueOf().toString();
      flightAirline = config.actors.airline1;
      passenger = config.actors.passenger1;
      insuranceAmount = web3.utils.toWei('1', 'ether');
    });
    
    it("Flights can be registered by the airline", async () => {
      let tx = await app.registerFlight(flight, departureTime, {from: config.actors.airline1});
      expectEvent(tx, 'FlightRegistered', {
        airlineAddress: flightAirline,
        flight: flight,
        departureTime: departureTime
      });

      let registrationStatus = await app.isFlightRegistered(flightAirline, flight, departureTime);
      assert.equal(registrationStatus, true, "Flight is not registered");
    });

    it("Passengers can purchase flight insurance on a flight for up to 1 ether", async () => {
      let tx = await app.buyFlightInsurance(flightAirline, flight, departureTime, {from: passenger, value: insuranceAmount});
      expectEvent(tx, 'InsurancePurchased', {
        passengerAddress: passenger,
        amount: insuranceAmount
      });
    });
  }); // End passengers

  /****************************************************************************************/
  /* Oracles Business Logic                                                                                 */
  /****************************************************************************************/

  describe("Oracles Business Logic", async () => {
    var TEST_ORACLES_COUNT = 20;

    var flight;
    var departureTime;
    var flightAirline;
    var passenger;
    var insuranceAmount;

    var STATUS_CODE_UNKNOWN;
    var STATUS_CODE_ON_TIME;
    var STATUS_CODE_LATE_AIRLINE;
    var STATUS_CODE_LATE_WEATHER;
    var STATUS_CODE_LATE_TECHNICAL;
    var STATUS_CODE_LATE_OTHER;

    before('Setup oracle environment', async () => {
      STATUS_CODE_UNKNOWN = 0;
      STATUS_CODE_ON_TIME = 10;
      STATUS_CODE_LATE_AIRLINE = 20;
      STATUS_CODE_LATE_WEATHER = 30;
      STATUS_CODE_LATE_TECHNICAL = 40;
      STATUS_CODE_LATE_OTHER = 50;
  
      flight = 'NH 278';
      departureTime = new Date(2020, 11, 30, 18, 0, 0).valueOf().toString();
      flightAirline = config.actors.airline1;
      passenger = config.actors.passenger1;
      insuranceAmount = web3.utils.toWei('1', 'ether');  
    });

    it('Can register oracles', async () => {
      let fee = await app.REGISTRATION_FEE.call();

      // ACT
      for(let a=1; a<TEST_ORACLES_COUNT; a++) {      
        await app.registerOracle({ from: accounts[a], value: fee });
        let result = await app.getMyIndexes.call({from: accounts[a]});
        console.log(`Oracle Registered: ${result[0]}, ${result[1]}, ${result[2]}`);
      }
    });

    it('Can request flight status', async () => {
      // Submit a request for oracles to get status information for a flight
      await app.fetchFlightStatus(flightAirline, flight, departureTime);
      // ACT

      // Since the Index assigned to each test account is opaque by design
      // loop through all the accounts and for each account, all its Indexes (indices?)
      // and submit a response. The contract will reject a submission if it was
      // not requested so while sub-optimal, it's a good test of that feature
      for(let a=1; a<TEST_ORACLES_COUNT; a++) {

        // Get oracle information
        let oracleIndexes = await app.getMyIndexes.call({ from: accounts[a]});
        for(let idx=0;idx<3;idx++) {
          try {
            // Submit a response...it will only be accepted if there is an Index match
            await app.submitOracleResponse(oracleIndexes[idx], flightAirline, flight, departureTime, STATUS_CODE_ON_TIME, { from: accounts[a] });

          }
          catch(e) {
            // Enable this when debugging
            console.log('\nError', idx, oracleIndexes[idx].toNumber(), flight);
          }
        }
      }
    });

    it("If flight is delayed due to airline fault, passenger receives credit of 1.5X the amount they paid", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
      // expectEvent(tx, 'InsurancePayout', {
      //   passengerAddress: flightAirline,
      //   flight: flight,
      //   departureTime: departureTime
      // });
    });

    //   it("Passenger can withdraw any funds owed to them as a result of receiving credit for insurance payout", async () => {
    //     // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    //   });
    // });

    // it('', async () => {
    //   // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    // });

  }); // End oracles

}); // End contract