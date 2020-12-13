const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

module.exports = async (deployer, network, accounts) => {

    let contractOwner = accounts[0];
    let firstAirline = accounts[1];

    await deployer.deploy(FlightSuretyData, {from: contractOwner});
    await deployer.deploy(FlightSuretyApp, FlightSuretyData.address, {from: contractOwner});

    // authorize the app to call the data contract
    let data = await FlightSuretyData.deployed();
    await data.authorizeCaller(FlightSuretyApp.address, {from: contractOwner});
    
    // nominate and register the first airline from the data contract
    await data.nominateAirline(firstAirline);
    await data.registerAirline(firstAirline);
    
    let app = await FlightSuretyApp.deployed()

    console.log(`Data address: ${data.address}`);
    console.log(`App address: ${app.address}`);
    
    let config = {
        localhost: {
            url: 'http://localhost:8545',
            dataAddress: data.address,
            appAddress: app.address,
        }
    }

    fs.writeFileSync(__dirname + '/../src/dapp/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
    fs.writeFileSync(__dirname + '/../src/server/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
    fs.writeFileSync(__dirname + '/../src/flutter_dapp/assets/contracts/config.json',JSON.stringify(config, null, '\t'), 'utf-8');

    // copy build outputs to Futter dApp
    // var buildFolder = __dirname + '/../build/contracts/';
    // var destFolder = __dirname + '/../src/flutter_dapp/assets/contracts/';

    // fs.copyFileSync(buildFolder + 'FlightSuretyApp.json', destFolder + 'FlightSuretyApp.json');
    // fs.copyFileSync(buildFolder + 'FlightSuretyData.json', destFolder + 'FlightSuretyData.json');
    // fs.copyFileSync(buildFolder + 'Migrations.json', destFolder + 'Migrations.json');
    // fs.copyFileSync(buildFolder + 'SafeMath.json', destFolder + 'SafeMath.json');
}