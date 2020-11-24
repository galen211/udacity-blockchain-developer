var Test = require("../config/testConfig.js");
var BigNumber = require("bignumber.js");
const truffleAssert = require("truffle-assertions");

contract("Flight Surety Tests", async (accounts) => {
  var config;
  before("setup contract", async () => {
    config = await Test.Config(accounts);
  });

  /****************************************************************************************/
  /* Operations and Settings                                                              */
  /****************************************************************************************/
  describe("Operations and Settings", () => {
    it(`has correct initial isOperational() value`, async () => {
      let status = await config.flightSuretyData.isOperational.call();
      assert.equal(status, true, "Incorrect initial operating status value");
    });

    it(`can block access to setOperatingStatus() for non-Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await config.flightSuretyData.setOperatingStatus(false, {
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

    it(`can allow access to setOperatingStatus() for Contract Owner account`, async () => {
      let accessDenied = false;
      try {
        await config.flightSuretyData.setOperatingStatus(false, { from: config.contractOwner });
      } catch (e) {
        accessDenied = true;
      }
      assert.equal(
        accessDenied,
        false,
        "Access not restricted to Contract Owner"
      );
    });

    it(`can block access to functions using requireIsOperational when operating status is false`, async () => {
      await config.flightSuretyData.setOperatingStatus(false, {from: config.contractOwner});
      let reverted = false;
      try {
        await config.flightSurety.registerAirline(config.actors.airline2, {from: airline1});
      } catch (e) {
        reverted = true;
      }
      assert.equal(
        reverted,
        true,
        "Access not blocked for requireIsOperational"
      );
      // Set it back for other tests to work
      await config.flightSuretyData.setOperatingStatus(true, {from: config.contractOwner});
    });
  });

  /****************************************************************************************/
  /* Airline Business Logic                                                               */
  /****************************************************************************************/

  describe("Airline Business Logic", () => {
    it("first airline is registered when contract is deployed.", async () => {
      let firstAirline = config.actors.airline1;
      let result = await config.flightSuretyApp.isAirlineRegistered(firstAirline);
      assert(result, true, "First airline is not registered upon deployment");
    });

    it("airline cannot register an Airline using registerAirline() if it is not funded", async () => {
      // ARRANGE
      let newAirline = config.actors.airline2;

      // ACT
      try {
        await config.flightSuretyApp.registerAirline(newAirline, {
          from: config.actors.airline1,
        });
      } catch (e) {
        console.log(e);
      }
      let result = await config.flightSuretyData.isAirlineRegistered(newAirline);

      // ASSERT
      assert.equal(
        result,
        false,
        "Airline should not be able to register another airline if it hasn't provided funding"
      );
    });

    it("Only existing airline may register a new airline until there are at least four airlines registered", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });

    it("Registration of fifth and subsequent airlines requires multi-party consensus of 50% of registered airlines", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });

    it("Airline can be registered, but does not participate in contract until it submits funding of 10 ether", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });
  });

  /****************************************************************************************/
  /* Passenger Business Logic                                                                                 */
  /****************************************************************************************/

  describe("Passenger Business Logic", () => {
    // might be tests in the oracles
    it("Passengers may pay up to 1 ether for purchasing flight insurance", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });

    it("If flight is delayed due to airline fault, passenger receives credit of 1.5X the amount they paid", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });

    it("Passenger can withdraw any funds owed to them as a result of receiving credit for insurance payout", async () => {
      // TODO: Demonstrated either with Truffle test or by making call from client Dapp
    });
  });

  // it('', async () => {
  //   // TODO: Demonstrated either with Truffle test or by making call from client Dapp
  // });
});
