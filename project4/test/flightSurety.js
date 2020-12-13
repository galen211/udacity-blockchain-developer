var Test = require("../config/testConfig.js");
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

contract("Flight Surety Tests", async (accounts) => {
  let config;
  let data;
  let app;
  let actors;
  let airlines;
  let passengers;
  let flights;
  let oracles;

  before("setup contract", async () => {
    config = await Test.Config(accounts);
    data = config.flightSuretyData;
    app = config.flightSuretyApp;
    actors = config.actors;
    airlines = config.airlines;
    passengers = config.passengers;
    flights = config.flights;
    oracles = config.oracles;
  });

  describe("Environment configuration", () => {

    it("Environment is properly configured", () => {
      assert.notEqual(config, null);
      assert.notEqual(data, null);
      assert.notEqual(app, null);
      assert.notEqual(actors, null);
      assert.notEqual(flights, null);
      assert.notEqual(oracles, null);

      console.log("------Actor Accounts------");
      for (const key in actors) {
        if (actors.hasOwnProperty(key)) {
          console.log(`${key}: ${actors[key]}`);
        }
      }

      console.log("------Flights------");
      for (const key in flights) {
        if (flights.hasOwnProperty(key)) {
          console.log(`${key}: ${flights[key]}`);
        }
      }

      console.log("------Oracles------");
      oracles.forEach((oracle, index) => {
          console.log(`oracle${index+1}: ${oracle}`);
      });
    });
  });
  
  describe("Operations and Settings", () => {
    it(`Has correct initial isOperational() value`, async () => {
      let status = await data.isOperational();
      assert.equal(status, true, "Incorrect initial operating status value");
    });

    it(`Can block access to setOperatingStatus() for non-Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await data.setOperatingStatus(false, {
          from: actors.airline2,
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
        await app.registerAirline(actors.airline2, {from: airline1});
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

  describe("Business Logic", () => {

    describe("Scenario: Only existing airline may register a new airline until there are at least four airlines registered", async () => {

      it("First airline is registered when contract is deployed.", async () => {
        let tx = false;
        let threwError = false;
        try {
          tx = await app.isAirlineRegistered(actors.airline1);
        } catch (error) {
          threwError = true;
        }
        assert.equal(tx, true, "First airline is not registered upon deployment");
        assert.equal(threwError, false, "Test threw an unexpected error");
      });

      it("Unregistered airline cannot register a new airline", async () => {
        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline3 }),
          "Only a funded airline may register an airline or participate in consensus"
        );
      });

      it("Airline can be registered, but it cannot participate in contract until it submits funding of 10 ether", async () => {
        let currentDepositAmount = await data.amountAirlineFunds.call(actors.airline1);
        assert.equal(currentDepositAmount, 0, "Airline 1 should not be funded yet");

        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline1 }),
          "Only a funded airline may register an airline or participate in consensus"
        );

        let fundingAmount = web3.utils.toWei('10', 'ether'); // airline 1 submits funding

        let tx = await app.fundAirline({ from: actors.airline1 , value: fundingAmount })
        expectEvent(tx, 'AirlineFunded', {
          airlineAddress: actors.airline1,
          amount: fundingAmount
        });

        var amount = (await data.amountAirlineFunds.call(actors.airline1)).toString();
        assert.equal(amount, fundingAmount, "Expected 10 ether funding");
      });

      it("First airline registers the second airline.", async () => {
        let tx = await app.registerAirline(actors.airline2, { from: actors.airline1 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline2
        });
      });

      it("Cannot re-register an airline that has already been registered", async () => {
        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline1 }),
          "Airline is already registered"
        );
      });

      it("Second airline registers the third airline.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: actors.airline2 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline2,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(actors.airline3, { from: actors.airline2 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline3
        });
      });

      it("Third airline registers the fourth airline.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: actors.airline3 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline3,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(actors.airline4, { from: actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline4
        });
      });
    });

    describe("Scenario: Registration of fifth and subsequent airlines requires multi-party consensus of 50% of registered airlines", () => {

      it("Fourth airline cannot register the fifth without consensus.", async () => {
        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx0 = await app.fundAirline({ from: actors.airline4 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline4,
          amount: fundingAmount
        });
        
        let tx = await app.registerAirline(actors.airline5, { from: actors.airline4 });
        expectEvent.notEmitted(tx, 'AirlineRegistered');
        
        let votes = await data.numberAirlineVotes.call(actors.airline5);
        assert.equal(votes, 1, "Expect only one vote has been cast for Airline #5");
      });

      it("Upon reaching 50% threshold of votes of all registered airlines, registration is successful", async () => {
        let tx = await app.registerAirline(actors.airline5, { from: actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline5
        });
        let votes = await data.numberAirlineVotes.call(actors.airline5);
        assert.equal(votes, 2, "Expect two votes have been cast for Airline #5");

        let fundingAmount = web3.utils.toWei('10', 'ether'); 
        let tx1 = await app.fundAirline({ from: actors.airline5 , value: fundingAmount })

        expectEvent(tx1, 'AirlineFunded', {
          airlineAddress: actors.airline5,
          amount: fundingAmount
        });
      });

      it("All airlines are funded", async () => {
        airlines.forEach(async (airlineAddress) => {
          let result = await app.isAirlineFunded(airlineAddress);
          assert.equal(result, true);
        });
      });
    });

    describe("Scenario: Airlines can register flights and passengers can purchase insurance", () => {
      
      it('Each airline registers a flight', async () => {

        flights.forEach(async (flight) => {
        
          let flightAirline = flight[0];
          let flightName = flight[1];
          let departureTime = flight[2];

          let tx = await app.registerFlight(flightName, departureTime, {from: flightAirline});
          expectEvent(tx, 'FlightRegistered', {
            airlineAddress: flightAirline,
            flight: flightName,
            departureTime: departureTime
          });
  
          let registrationStatus = await app.isFlightRegistered(flightAirline, flightName, departureTime);
          assert.equal(registrationStatus, true, "Flight is not registered");
        });
      });

      it("Passengers can purchase flight insurance on a flight for up to 1 ether", async () => {
        let insuranceAmount = web3.utils.toWei('1', 'ether');
  
        passengers.forEach(async (passengerAddress, index) => {
          let flight = flights[index];
          let flightAirline = flight[0];
          let flightName = flight[1];
          let departureTime = flight[2];
  
          let tx = await app.buyFlightInsurance(flightAirline, flightName, departureTime, {from: passengerAddress, value: insuranceAmount});
          expectEvent(tx, 'InsurancePurchased', {
            passengerAddress: passengerAddress,
            amount: insuranceAmount
          });
        });
      });
    });

    describe("Scenario: Can request flight status from oracles", () => {
  
      let STATUS_CODE_UNKNOWN;
      let STATUS_CODE_ON_TIME;
      let STATUS_CODE_LATE_AIRLINE;
      let STATUS_CODE_LATE_WEATHER;
      let STATUS_CODE_LATE_TECHNICAL;
      let STATUS_CODE_LATE_OTHER;

      before(() => {
        STATUS_CODE_UNKNOWN = 0;
        STATUS_CODE_ON_TIME = 10;
        STATUS_CODE_LATE_AIRLINE = 20;
        STATUS_CODE_LATE_WEATHER = 30;
        STATUS_CODE_LATE_TECHNICAL = 40;
        STATUS_CODE_LATE_OTHER = 50;
      });
  
      it('Oracle registration fails if fee insufficient', async () => {
        let insufficientFee = web3.utils.toWei('0.5', 'ether');
        await expectRevert(
          app.registerOracle({ from: oracles[0], value: insufficientFee }),
          "Registration fee is required"
        );
      });
  
      it('Can register oracles', async () => {
        let fee = await app.REGISTRATION_FEE.call();
        oracles.forEach(async (oracle) => {
          await app.registerOracle({ from: oracle, value: fee });
          let isRegistered = await app.isOracleRegistered(oracle);
          assert.equal(isRegistered, true, `Oracle ${oracle} was not registered`);
        });
      });
        
      it('Can request flight status', async () => {
        flights.forEach(async (value) => {
          let flightAirline = value[0];
          let flightName = value[1];
          let departureTime = value[2];

          console.log(`Requesting flight status for: ${flightName}`);
          await app.fetchFlightStatus(flightAirline, flightName, departureTime);
          oracles.forEach(async (oracle) => {
            let oracleIndexes = await app.getMyIndexes.call({ from: oracle});
            for(let idx=0;idx<3;idx++) {
              try {
                await app.submitOracleResponse(oracleIndexes[idx], flightAirline, flightName, departureTime, STATUS_CODE_ON_TIME, { from: oracle });
              }
              catch(e) {
                // Enable this when debugging
                console.log('\nError', idx, oracleIndexes[idx].toNumber(), flightName);
              }
            }
          });
        });
      });
  
      it("A flight can be delayed if flight is delayed due to airline fault, passenger receives credit of 1.5X the amount they paid", async () => {
        let flightAirline = flights[0][0];
        let flightName = flights[0][1];
        let departureTime = flights[0][2]; 

        console.log(`Flight delayed: ${flightName}`);
        await app.fetchFlightStatus(flightAirline, flightName, departureTime);
        let tx;
        oracles.forEach(async (oracle) => {
          let oracleIndexes = await app.getMyIndexes.call({ from: oracle});
          for(let idx=0;idx<3;idx++) {
            try {
              tx = await app.submitOracleResponse(oracleIndexes[idx], flightAirline, flightName, departureTime, STATUS_CODE_LATE_AIRLINE, { from: oracle });
              expectEvent(tx, 'OracleReport', {
                airline: flightAirline,
                flight: flightName,
                departureTime: departureTime,
                status: STATUS_CODE_LATE_AIRLINE
              });
            }
            catch(e) {
              // Enable this when debugging
              console.log('\nError', idx, oracleIndexes[idx].toNumber(), flightName);
            }
          }
        });

        let status = app.officialFlightStatus(flightAirline, flightName, departureTime);
        assert.equal(status, STATUS_CODE_LATE_AIRLINE);
      });

      it("If a flight is delayed due to airline, an InsurancePayout event is emitted", async () => {

        let flightAirline = flights[1][0];
        let flightName = flights[1][1];
        let departureTime = flights[1][2]; 

        let tx = app.processFlightStatus.call(
          flightAirline,
          flightName,
          departureTime,
          STATUS_CODE_LATE_AIRLINE
        );

        expectEvent(tx, 'InsurancePayout', {
          airlineAddress: flightAirline,
          flight: flightName,
          departureTime: departureTime
        });

      });
  
      //   it("Passenger can withdraw any funds owed to them as a result of receiving credit for insurance payout", async () => {
      //     // TODO: Demonstrated either with Truffle test or by making call from client Dapp
      //   });
      // });
  
      // it('', async () => {
      //   // TODO: Demonstrated either with Truffle test or by making call from client Dapp
      // });
  
    }); // End oracles
  });
});