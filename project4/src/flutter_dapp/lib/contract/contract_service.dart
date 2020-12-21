import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'flight.dart';

final App appConstants = App.settings;

class ContractService {
  Web3Client client;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<String, ContractEvent> contractEvents;

  ContractService() {
    Prerequisites prerequisites = Prerequisites();
    appContract = prerequisites.appContract;
    appContractAddress = prerequisites.appContractAddress;

    contractFunctions = prerequisites.contractFunctions;
    contractEvents = prerequisites.contractEvents;

    client = Web3Client(appConstants.ethRpcServer, http.Client(),
        socketConnector: () {
      return IOWebSocketChannel.connect(appConstants.wsUrl).cast<String>();
    });
  }

  Future<bool> isOperational(EthereumAddress sender) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isOperational'],
        params: []);
    return response[0];
  }

  Future<String> setOperatingStatus(bool mode, Credentials credentials) async {
    final tx = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: appContract,
          function: contractFunctions['setOperationalStatus'],
          parameters: [mode]),
      fetchChainIdFromNetworkId: true,
    );
    return tx;
  }

  Future<bool> isAirlineRegistered(
      EthereumAddress airlineAddress, EthereumAddress sender) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isAirlineRegistered'],
        params: [airlineAddress]);
    return response[0];
  }

  Future<bool> isAirlineFunded(
      EthereumAddress airlineAddress, EthereumAddress sender) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isAirlineFunded'],
        params: [airlineAddress]);
    return response[0];
  }

  Future<List<dynamic>> registerAirline(
      EthereumAddress airlineAddress, EthereumAddress sender) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['registerAirline'],
        params: [airlineAddress]);
    return response;
  }

  Future<void> fundAirline(EthereumAddress sender, Credentials credentials,
      EtherAmount value) async {
    ContractFunction appFunction = contractFunctions['fundAirline'];
    Transaction.callContract(
        contract: appContract, function: appFunction, parameters: []);
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: appContract,
          function: appFunction,
          parameters: [],
          value: value),
    );
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
