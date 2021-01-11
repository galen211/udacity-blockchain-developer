#!/bin/bash

docker run -v $(pwd)/contracts:/sources ethereum/solc:0.7.6 -o /sources/build --overwrite --abi /sources/FlightSuretyApp.sol

cp -rf contracts/build src/flutter_dapp/assets/contracts/