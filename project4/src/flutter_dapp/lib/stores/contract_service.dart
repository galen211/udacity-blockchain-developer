//import 'package:web_socket_channel/io.dart';
import 'dart:async';

import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/html.dart';

final App appConstants = App.settings;

class ContractService {
  Web3Client client;
  static const MAX_GAS = 500000;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<EventType, ContractEvent> contractEvents;

  Map<String, FlightStore> flightCodeToFlight;

  ContractService() {
    Prerequisites prerequisites = Prerequisites();
    appContract = prerequisites.appContract;
    appContractAddress = prerequisites.appContractAddress;

    contractFunctions = prerequisites.contractFunctions;
    contractEvents = prerequisites.contractEvents;

    flightCodeToFlight = prerequisites.flightMap;

    client = Web3Client(appConstants.ethRpcServer, http.Client(),
        socketConnector: () {
      return HtmlWebSocketChannel.connect(appConstants.wsUrl).cast<String>();
      //return IOWebSocketChannel.connect(appConstants.wsUrl).cast<String>();
      // need to use HtmlWebSocketChannel bc web https://pub.dev/packages/web_socket_channel
    });
  }

  Stream<List<dynamic>> registerStream(ContractEvent contractEvent) {
    return client
        .events(
            FilterOptions.events(contract: appContract, event: contractEvent))
        .map((event) => contractEvent.decodeResults(event.topics, event.data));
  }

  Future<EtherAmount> getAccountBalance({EthereumAddress account}) async {
    EtherAmount balance = await client.getBalance(account);
    return balance;
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
        parameters: [mode],
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<bool> isAirlineNominated(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isAirlineNominated'],
        params: [airlineAddress]);
    return response[0] as bool;
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

  Future<int> airlineMembership(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['airlineMembership'],
        params: [airlineAddress]);
    BigInt membership = response[0] as BigInt;
    return membership.toInt();
  }

  Future<void> registerAirline(
      {EthereumAddress airlineAddress,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['registerAirline'],
        parameters: [airlineAddress],
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<void> registerOracle(
      {EtherAmount oracleRegistrationFee,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['registerOracle'],
        parameters: [],
        from: sender,
        value: oracleRegistrationFee,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<void> withdrawBalance(
      {EtherAmount withdrawalAmount,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['withdrawBalance'],
        parameters: [],
        from: sender,
        value: withdrawalAmount,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<EtherAmount> amountAirlineFunds(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['amountAirlineFunds'],
        params: [airlineAddress]);
    return EtherAmount.inWei(response[0]);
  }

  Future<int> numberAirlineVotes(
      {EthereumAddress airlineAddress, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['numberAirlineVotes'],
        params: [airlineAddress]);
    BigInt votes = response[0] as BigInt;
    return votes.toInt();
  }

  Future<void> nominateAirline(
      {EthereumAddress airlineAddress,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['nominateAirline'],
        parameters: [
          airlineAddress,
        ],
        from: sender,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
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
        value: value,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<void> registerFlight(
      {FlightStore flight,
      EthereumAddress sender,
      Credentials credentials}) async {
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
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<bool> isFlightRegistered(
      {FlightStore flight, EthereumAddress sender}) async {
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

  List<FlightStore> getUnregisteredFlights() {
    return flightCodeToFlight.values.toList();
  }

  Future<void> buyFlightInsurance(
      {FlightStore flight,
      EtherAmount insuranceAmount,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['buyFlightInsurance'],
        parameters: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ],
        from: sender,
        value: insuranceAmount,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<void> fetchFlightStatus(
      {FlightStore flight,
      EthereumAddress sender,
      Credentials credentials}) async {
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['fetchFlightStatus'],
        parameters: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ],
        from: sender,
        maxGas: MAX_GAS,
      ),
      fetchChainIdFromNetworkId: true,
    );
  }

  Future<bool> isPassengerInsured(
      {FlightStore flight,
      EthereumAddress passengerAddress,
      EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isPassengerInsured'],
        params: [
          passengerAddress,
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ]);
    return response[0] as bool;
  }

  Future<bool> isPaidOut({FlightStore flight, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['isPaidOut'],
        params: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ]);
    return response[0] as bool;
  }

  Future<int> officialFlightStatus(
      {FlightStore flight, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['officialFlightStatus'],
        params: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ]);
    final result = response[0] as BigInt;
    return result.toInt();
  }

  Future<EtherAmount> passengerBalance(
      {EthereumAddress passenger, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['passengerBalance'],
        params: [passenger]);
    return EtherAmount.inWei(response[0]);
  }
}
