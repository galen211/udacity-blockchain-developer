import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';

export default class Contract {
    constructor(network, callback) {

        let config = Config[network];
        this.web3 = new Web3(new Web3.providers.HttpProvider(config.url));
        this.flightSuretyApp = new this.web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);
        this.initialize(callback);
        this.owner = null;
        this.airlines = [];
        this.passengers = [];
    }

    initialize(callback) {
        this.web3.eth.getAccounts((error, accts) => {
           
            this.owner = accts[0];

            let counter = 1;
            
            while(this.airlines.length < 5) {
                this.airlines.push(accts[counter++]);
            }

            while(this.passengers.length < 5) {
                this.passengers.push(accts[counter++]);
            }

            callback();
        });
    }

    async buy(passenger, insurance, flight, callback){
        let self = this;
        let amount = self.web3.utils.toWei(insurance);
        this.addFunds(passenger, insurance);
        await self.flightSuretyApp.methods.buy(insurance, flight).send({ from: passenger, value: amount,  gas:3000000 }, (error, result) => {
                callback(error, result);
            });
        console.log("buy"); 
    }

    async show(passenger, callback){
        let self = this;
        self.funds = await self.flightSuretyApp.methods.getPassengersInsurance().call({from: passenger});
        console.log("show");
    }

    async pay(passenger, callback){
        let self = this;
        let passengerCurrentFund = this.getFunds(passenger);
        let withdrawAmount = self.web3.utils.toWei(passengerCurrentFund);
        await self.flightSuretyApp.methods.pay().send({from: passenger, value: passengerCurrentFund, gas:3000000}, (error, result) => {
                if(error){
                    console.log(error);
                }else {
                    console.log(result);
                    callback(result);
                }
            });
        console.log("pay");
    }

    async registerAirline(airline, callback){
        let self = this;
        await self.flightSuretyApp.methods.registerAirline(airline).send({ from: self.owner}, (error, result) => {
                callback(error, result);
            });
    }

    async sendFundToAirline(airline,funds, callback){
        let self = this;
        let amount = self.web3.utils.toWei(funds, "ether").toString();
        await self.flightSuretyApp.methods.fundAirline().send({ from: airline, value: amount}, (error, result) => {
                callback(error, result);
            });
        console.log("sendFundToAirline");
    }

    addFunds(passenger, insurance){
        for (var i=0; i < this.passengers.length; i++) {
            if (this.passengers[i].account === passenger) {
                this.passengers[i].passengerFund = insurance;
            }
        }
        console.log("addFunds");
    }

    getFunds(passenger) {
        let result = 0;
        for (var i=0; i < this.passengers.length; i++) {
            if (this.passengers[i].account === passenger) {
                result = this.passengers[i].passengerFund;
            }
        }
        return 'result';
    }

    isOperational(callback) {
       let self = this;
       self.flightSuretyApp.methods
            .isOperational()
            .call({ from: self.owner}, callback);
    }

    fetchFlightStatus(flight, callback) {
        let self = this;
        let payload = {
            airline: self.airlines[0],
            flight: flight,
            timestamp: Math.floor(Date.now() / 1000)
        } 
        self.flightSuretyApp.methods
            .fetchFlightStatus(payload.airline, payload.flight, payload.timestamp)
            .send({ from: self.owner}, (error, result) => {
                callback(error, payload);
            });
    }
}