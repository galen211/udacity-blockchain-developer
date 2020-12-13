import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dapp/data/accounts.dart';
import 'package:flutter_dapp/data/config.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'flight.dart';

class ContractService {
  Accounts accounts;
  Web3Client web3Client;
  String wsUrl = 'ws://localhost:8545';

  ConfigFile configFile;
  List<Actor> actors;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  Map<String, ContractFunction> contractFunctions;

  ContractService() {
    initializeContractService();
    initializeContractFunctions();
  }

  void initializeContractService() async {
    String data = await rootBundle.loadString('assets/contracts/config.json');
    var configMap = json.decode(data);
    configFile = ConfigFile.fromJson(configMap);

    web3Client = Web3Client(configFile.localhost.url, http.Client(),
        socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    appContractAddress =
        EthereumAddress.fromHex(configFile.localhost.appAddress);

    final appContractString = await rootBundle
        .loadString('assets/contracts/build/FlightSuretyApp.abi');

    appContract = DeployedContract(
        ContractAbi.fromJson(appContractString, 'FlightSuretyApp'),
        appContractAddress);
  }

  void initializeContractFunctions() {
    contractFunctions = Map<String, ContractFunction>();
    final appIsOperational = appContract.function('isOperational');
  }

  Future<void> registerAirline(
      EthereumAddress airlineAddress, EthereumAddress sender) async {
    ContractFunction appFunction = contractFunctions['registerAirline'];
    try {
      final response = await web3Client.call(
          sender: sender,
          contract: appContract,
          function: appFunction,
          params: [airlineAddress]);
    } catch (e) {
      debugPrint(e);
    }

    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> fundAirline(
      EthereumAddress airlineAddress, EthereumAddress sender) async {
    ContractFunction appFunction = contractFunctions['fundAirline'];
    try {
      final response = await web3Client.call(
          sender: sender,
          contract: appContract,
          function: appFunction,
          params: [airlineAddress]);
    } catch (e) {
      debugPrint(e);
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> registerFlight(Flight flight) async {
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<List<Flight>> getFlights() async {
    List<Flight> flights = [];
    for (var i = 0; i < 5; i++) {
      Flight flight = Flight(
          flightName: 'Flight $i',
          departureTime: DateTime(2020, 1, 21),
          flightAirline: "0x8923dd8sKD",
          flightStatus: 30,
          selected: false);
      flights.add(flight);
    }
    return Future.delayed(Duration(milliseconds: 500)).then((_) => flights);
  }

  Future<void> purchaseInsurance(double amountEth) async {
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<FlightStatus> checkFlightStatus(Flight flight) async {
    return Future.delayed(Duration(milliseconds: 500))
        .then((value) => FlightStatus.LateAirline);
  }

  Future<double> queryAvailableBalance(String account) async {
    return Future.delayed(Duration(milliseconds: 500)).then((value) => 1000.0);
  }

  Future<void> withdrawAvailableBalance() async {
    return Future.delayed(Duration(milliseconds: 500));
  }
}
