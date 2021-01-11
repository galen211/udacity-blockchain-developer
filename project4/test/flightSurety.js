var Test = require('../config/testConfig.js');
const { expect } = require('chai');

const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
  balance,
  ether,
} = require('@openzeppelin/test-helpers');

contract('Flight Surety App Functionality', async (accounts) => {
  let config;
  let data;
  let app;
  let actors;
  let airlines;
  let passengers;
  let flights;
  let oracles;
  let actorNames;

  before('setup contract', async () => {
    config = await Test.Config(accounts);
    data = config.flightSuretyData;
    app = config.flightSuretyApp;
    actors = config.actors;
    airlines = config.airlines;
    passengers = config.passengers;
    flights = config.flights;
    oracles = config.oracles;
    actorNames = config.actorNames;    
  });

  describe('Environment configuration', () => {

    it('Environment is properly configured', () => {
      assert.notEqual(config, null);
      assert.notEqual(data, null);
      assert.notEqual(app, null);
      assert.notEqual(actors, null);
      assert.notEqual(flights, null);
      assert.notEqual(oracles, null);

      console.log('------Actor Accounts------');
      for (const key in actors) {
        if (actors.hasOwnProperty(key)) {
          console.log(`${key}: ${actors[key]}`);
        }
      }

      console.log('------Flights------');
      for (const key in flights) {
        if (flights.hasOwnProperty(key)) {
          console.log(`${key}: ${flights[key]}`);
        }
      }

      console.log('------Oracles------');
      oracles.forEach((oracle, index) => {
          console.log(`oracle${index+1}: ${oracle}`);
      });
    });
  });
  
  describe('Operations and Settings', () => {
    it(`Has correct initial isOperational() value`, async () => {
      let status = await app.isOperational();
      assert.equal(status, true, 'Incorrect initial operating status value');
    });

    it(`Can block access to setOperatingStatus() for non-Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await app.setOperationalStatus(false, {
          from: actors.airline2,
        });
      } catch (e) {
        accessDenied = true;
      }
      assert.equal(
        accessDenied,
        true,
        'Access not restricted to Contract Owner'
      );
    });

    it(`Can allow access to setOperatingStatus() for Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await app.setOperationalStatus(false, { from: config.contractOwner });
      } catch (e) {
        accessDenied = true;
      }
      assert.equal(
        accessDenied,
        false,
        'Access not restricted to Contract Owner'
      );
    });

    it(`Can block access to functions using requireIsOperational when operating status is false`, async () => {
      await app.setOperationalStatus(false, {from: config.contractOwner});
      let reverted = false;
      try {
        await app.registerAirline(actors.airline2, {from: airline1});
      } catch (e) {
        reverted = true;
      }
      assert.equal(
        reverted,
        true,
        'Access not blocked for requireIsOperational'
      );
      // Set it back for other tests to work
      await app.setOperationalStatus(true, {from: config.contractOwner});
    });
  });

  describe('Business Logic', () => {

    describe('Scenario: Only existing airline may register a new airline until there are at least four airlines registered', async () => {

      before('Nominate airlines', async () => {
        let tx2 = await app.nominateAirline(actors.airline2, { from: actors.airline1 });
        expectEvent(tx2, 'AirlineNominated', {
          airlineAddress: actors.airline2,
        });

        let tx3 = await app.nominateAirline(actors.airline3, { from: actors.airline1 });
        expectEvent(tx3, 'AirlineNominated', {
          airlineAddress: actors.airline3,
        });

        let tx4 = await app.nominateAirline(actors.airline4, { from: actors.airline1 });
        expectEvent(tx4, 'AirlineNominated', {
          airlineAddress: actors.airline4,
        });

        let tx5 = await app.nominateAirline(actors.airline5, { from: actors.airline1 });
        expectEvent(tx5, 'AirlineNominated', {
          airlineAddress: actors.airline5,
        });
      });

      it('First airline is registered when contract is deployed.', async () => {
        let tx = false;
        let threwError = false;
        try {
          tx = await app.isAirlineRegistered(actors.airline1);
        } catch (error) {
          threwError = true;
        }
        assert.equal(tx, true, 'First airline is not registered upon deployment');
        assert.equal(threwError, false, 'Test threw an unexpected error');
      });

      it('Unregistered airline cannot register a new airline', async () => {
        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline3 }),
          'Only a funded airline may register an airline or participate in consensus'
        );
      });

      it('Airline can be registered, but it cannot participate in contract until it submits funding of 10 ether', async () => {
        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline1 }),
          'Only a funded airline may register an airline or participate in consensus'
        );

        let fundingAmount = ether('10');

        let tx = await app.fundAirline({ from: actors.airline1 , value: fundingAmount })
        expectEvent(tx, 'AirlineFunded', {
          airlineAddress: actors.airline1,
          amount: fundingAmount
        });

        let result = await app.amountAirlineFunds(actors.airline1);
        expect(result).to.be.bignumber.equal(fundingAmount);
      });

      it('First airline registers the second airline.', async () => {
        let tx = await app.registerAirline(actors.airline2, { from: actors.airline1 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline2,
        });
      });

      it('Cannot re-register an airline that has already been registered', async () => {
        await expectRevert(
          app.registerAirline(actors.airline2, { from: actors.airline1 }),
          'Airline is already registered'
        );
      });

      it('Second airline registers the third airline.', async () => {
        let fundingAmount = ether('10');
        let tx0 = await app.fundAirline({ from: actors.airline2 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline2,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(actors.airline3, { from: actors.airline2 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline3,
        });
      });

      it('Third airline registers the fourth airline.', async () => {
        let fundingAmount = ether('10');
        let tx0 = await app.fundAirline({ from: actors.airline3 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline3,
          amount: fundingAmount
        });

        let tx = await app.registerAirline(actors.airline4, { from: actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline4,
        });
      });
    });

    describe('Scenario: Registration of fifth and subsequent airlines requires multi-party consensus of 50% of registered airlines', () => {

      it('Fourth airline cannot register the fifth without consensus.', async () => {
        let fundingAmount = ether('10');
        let tx0 = await app.fundAirline({ from: actors.airline4 , value: fundingAmount })

        expectEvent(tx0, 'AirlineFunded', {
          airlineAddress: actors.airline4,
          amount: fundingAmount
        });
        
        let tx = await app.registerAirline(actors.airline5, { from: actors.airline4 });
        expectEvent.notEmitted(tx, 'AirlineRegistered');
        
        let votes = await data.numberAirlineVotes.call(actors.airline5);
        assert.equal(votes, 1, 'Expect only one vote has been cast for Airline #5');
      });

      it('Upon reaching 50% threshold of votes of all registered airlines, registration is successful', async () => {
        let tx = await app.registerAirline(actors.airline5, { from: actors.airline3 });
        expectEvent(tx, 'AirlineRegistered', {
          airlineAddress: actors.airline5,
        });
        let votes = await data.numberAirlineVotes.call(actors.airline5);
        assert.equal(votes, 2, 'Expect two votes have been cast for Airline #5');

        let fundingAmount = ether('10');
        let tx1 = await app.fundAirline({ from: actors.airline5 , value: fundingAmount })

        expectEvent(tx1, 'AirlineFunded', {
          airlineAddress: actors.airline5,
          amount: fundingAmount
        });
      });

      it('All airlines are funded', async () => {
        airlines.forEach(async (airlineAddress) => {
          let result = await app.isAirlineFunded(airlineAddress);
          assert.equal(result, true);
        });
      });

      it('Balance of data contract is 50 ether', async () => {
        let tracker = await balance.tracker(data.address, unit = 'wei');
        let expected = ether('50');
        let actual = await tracker.get();
        expect(actual).to.be.bignumber.equal(expected);
      });
    });

    describe('Scenario: Airlines can register flights and passengers can purchase insurance', () => {
      
      it('Each airline registers a flight', async () => {

        flights.forEach(async (flight) => {
        
          let flightAirline = flight[0];
          let flightName = flight[1];
          let departureTime = flight[2];

          let tx = await app.registerFlight(flightName, departureTime, {from: flightAirline});
          expectEvent(tx, 'FlightRegistered', {
            airlineAddress: flightAirline,
            flight: flightName
          });
  
          let registrationStatus = await app.isFlightRegistered(flightAirline, flightName, departureTime);
          assert.equal(registrationStatus, true, 'Flight is not registered');
        });
      });

      it('Passengers can purchase flight insurance on a flight for up to 1 ether', async () => {
        let insuranceAmount = ether('1');

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
  });
});