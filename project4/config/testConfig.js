var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");

var Config = async (accounts) => {
    
    let TEST_ORACLES_COUNT = 20;

    let actors = {
        contractOwner : accounts[0],
        airline1 : accounts[1],
        airline2 : accounts[2],
        airline3 : accounts[3],
        airline4 : accounts[4],
        airline5 : accounts[5],
        passenger1 : accounts[6],
        passenger2 : accounts[7],
        passenger3 : accounts[8],
        passenger4 : accounts[9],
        passenger5 : accounts[10]
    }

    let flights = [
        [actors.airline1, 'NH 87: JFK-HND', new Date(2020, 11, 30, 18, 0, 0).valueOf().toString()],
        [actors.airline2, 'AF 122: JFK-CDG', new Date(2020, 12, 30, 18, 0, 0).valueOf().toString()],
        [actors.airline3, 'CES 32: JFK-PVG', new Date(2020, 9, 30, 18, 0, 0).valueOf().toString()],
        [actors.airline4, 'UA 5: JFK-SFO', new Date(2020, 8, 30, 18, 0, 0).valueOf().toString()],
        [actors.airline5, 'CPA 9: JFK-HKG', new Date(2020, 7, 30, 18, 0, 0).valueOf().toString()]
    ];

    let actorNames = new Map([
        [ accounts[0], 'Contract Owner' ],
        [ accounts[1], 'Cathay Pacific' ],
        [ accounts[2], 'Delta Airines' ],
        [ accounts[3], 'Air France' ],
        [ accounts[4], 'British Airways' ],
        [ accounts[5], 'All Nippon Airways' ],
        [ accounts[6], 'Galen Simmons' ],
        [ accounts[7], 'John Whitehouse' ],
        [ accounts[8], 'Helene Seydoux' ],
        [ accounts[9], 'Lilah Gerard' ],
        [ accounts[10], 'Julie Waldmann' ]
    ]);

    airlines = accounts.slice(1,5);
    passengers = accounts.slice(6,10);
    oracles = accounts.slice(20,20+TEST_ORACLES_COUNT);

    let flightSuretyData = await FlightSuretyData.deployed();
    let flightSuretyApp = await FlightSuretyApp.deployed();

    return {
        contractOwner: actors.contractOwner,
        actors: actors,
        airlines: airlines,
        passengers: passengers,
        flights: flights,
        oracles: oracles,
        actorNames: actorNames,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};