import 'dart:async';

import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/html.dart';

final App appConstants = App.settings;

class ContractService {
  Web3Client client;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<String, ContractEvent> contractEvents;

  Map<String, Flight> flightCodeToFlight;

  ContractService() {
    Prerequisites prerequisites = Prerequisites();
    appContract = prerequisites.appContract;
    appContractAddress = prerequisites.appContractAddress;

    contractFunctions = prerequisites.contractFunctions;
    contractEvents = prerequisites.contractEvents;

    flightCodeToFlight = prerequisites.flightCodeToFlight;

    client = Web3Client(appConstants.ethRpcServer, http.Client(),
        socketConnector: () {
      return HtmlWebSocketChannel.connect(appConstants.wsUrl).cast<String>();
      // need to use HtmlWebSocketChannel bc web https://pub.dev/packages/web_socket_channel
    });
  }

  Stream<List<dynamic>> registerStream(ContractEvent contractEvent) {
    return client
        .events(
            FilterOptions.events(contract: appContract, event: contractEvent))
        .take(1)
        .map((event) => contractEvent.decodeResults(event.topics, event.data));
  }

  Future<EthereumAddress> getContractOwner({EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['contractOwner'],
        params: []);
    return response[0] as EthereumAddress;
  }

  Future<bool> isOperational({EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isOperational'],
        params: []);
    return response[0] as bool;
  }

  Future<void> setOperatingStatus({bool mode, Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: appContract,
          function: contractFunctions['setOperationalStatus'],
          parameters: [mode]),
    );
  }

  Future<bool> isAirlineRegistered(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isAirlineRegistered'],
        params: [airlineAddress]);
    return response[0] as bool;
  }

  Future<bool> isAirlineFunded(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isAirlineFunded'],
        params: [airlineAddress]);
    return response[0] as bool;
  }

  Future<void> registerAirline(
      {EthereumAddress airlineAddress,
      EthereumAddress sender,
      Credentials credentials}) async {
    final tx = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['registerAirline'],
        parameters: [airlineAddress],
      ),
    );
    print(tx.toString());
  }

  Future<int> numberAirlineVotes(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['numberAirlineVotes'],
        params: [airlineAddress]);
    return response[0] as int;
  }

  Future<void> nominateAirline(
      {EthereumAddress airlineAddress,
      String airlineName,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: appContract,
            function: contractFunctions['nominateAirline'],
            parameters: [
              airlineAddress,
              airlineName,
            ],
            from: sender));
  }

  Future<void> fundAirline(
      {EthereumAddress sender,
      Credentials credentials,
      EtherAmount value}) async {
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: appContract,
            function: contractFunctions['fundAirline'],
            parameters: [],
            from: sender,
            value: value));
  }

  Future<void> registerFlight(
      {Flight flight, EthereumAddress sender, Credentials credentials}) async {
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: appContract,
          function: contractFunctions['registerFlight'],
          parameters: [
            flight.flightIata,
            BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
          ],
          from: sender,
        ));
  }

  Future<bool> isFlightRegistered(
      {Flight flight, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isFlightRegistered'],
        params: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ]);
    return response[0] as bool;
  }

  List<Flight> getUnregisteredFlights() {
    return flightCodeToFlight.values.toList();
  }

  Future<void> purchaseInsurance(double amountEth) async {
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<FlightStatus> checkFlightStatus(Flight flight) async {
    return Future.delayed(Duration(milliseconds: 500))
        .then((value) => FlightStatus.LateAirline);
  }

  Future<EtherAmount> queryAvailableBalance(EthereumAddress address) async {
    EtherAmount balance = await client.getBalance(address);
    return balance;
  }

  Future<void> withdrawAvailableBalance() async {
    return Future.delayed(Duration(milliseconds: 500));
  }
}
