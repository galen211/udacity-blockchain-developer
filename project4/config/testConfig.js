var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");

var BigNumber = require('bignumber.js');

var Config = async (accounts) => {
    
    actors = {
        contractOwner : accounts[0],
        airline1 : accounts[0],
        airline2 : accounts[1],
        airline3 : accounts[2],
        airline4 : accounts[3],
        airline5 : accounts[4],
        passenger1 : accounts[5],
        passenger2 : accounts[6],
        passenger3 : accounts[7]
    }

    let flightSuretyData = await FlightSuretyData.deployed();
    let flightSuretyApp = await FlightSuretyApp.deployed();
    
    return {
        contractOwner: actors.contractOwner,
        weiMultiple: (new BigNumber(10)).pow(18),
        actors: actors,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};