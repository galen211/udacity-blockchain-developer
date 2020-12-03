var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");

var BigNumber = require('bignumber.js');

var Config = async (accounts) => {
    
    actors = {
        contractOwner : accounts[0],
        airline1 : accounts[1],
        airline2 : accounts[2],
        airline3 : accounts[3],
        airline4 : accounts[4],
        airline5 : accounts[5],
        passenger1 : accounts[6],
        passenger2 : accounts[7],
        passenger3 : accounts[8]
    }

    flights = {
        flight1 : [accounts[1], '87', 'JFK-HND'],
        flight2 : [accounts[2], '122', 'JFK-CDG'],
        flight3 : [accounts[3], '32', 'JFK-PVG'],
        flight4 : [accounts[4], '5', 'JFK-SFO'],
        flight5 : [accounts[5], '9', 'JFK-HKG']
    }

    let flightSuretyData = await FlightSuretyData.deployed();
    let flightSuretyApp = await FlightSuretyApp.deployed();
    
    return {
        contractOwner: actors.contractOwner,
        weiMultiple: (new BigNumber(10)).pow(18),
        actors: actors,
        flights: flights,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};