import 'dart:async';

import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/events.dart';
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
  Map<EventType, ContractEvent> contractEvents;

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
    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: appContract,
        function: contractFunctions['registerAirline'],
        parameters: [airlineAddress],
      ),
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
      ),
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
      ),
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

  Future<void> buyFlightInsurance(
      {Flight flight,
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
        ));
  }

  Future<void> fetchFlightStatus(
      {Flight flight, EthereumAddress sender, Credentials credentials}) async {
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
            from: sender));
  }

  Future<bool> isPassengerInsured(
      {Flight flight,
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

  Future<bool> isPaidOut({Flight flight, EthereumAddress sender}) async {
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

  Future<FlightStatus> officialFlightStatus(
      {Flight flight, EthereumAddress sender}) async {
    final response = await client.call(
        sender: sender,
        contract: appContract,
        function: contractFunctions['officialFlightStatus'],
        params: [
          flight.airlineAddress,
          flight.flightIata,
          BigInt.from(flight.scheduledDeparture.millisecondsSinceEpoch),
        ]);
    int status = response[0] as int;
    switch (status) {
      case 0:
        return FlightStatus.Unknown;
        break;
      case 10:
        return FlightStatus.OnTime;
        break;
      case 20:
        return FlightStatus.LateAirline;
        break;
      case 30:
        return FlightStatus.LateWeather;
        break;
      case 40:
        return FlightStatus.LateTechnical;
        break;
      case 50:
        return FlightStatus.LateOther;
        break;
      default:
        return FlightStatus.Unknown;
    }
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
