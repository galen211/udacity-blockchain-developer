import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dapp/data/accounts.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/config.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_dapp/data/flight_file.dart' as ff;
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:web3dart/web3dart.dart';

final App appConstants = App.settings;

class Prerequisites {
  Future _prerequisitesReady;
  static final Prerequisites _prerequisites = Prerequisites._internal();

  ConfigFile configFile;
  Accounts accounts;
  Map<String, Actor> nameToActor;
  List<Actor> actorList;

  Map<String, Flight> flightCodeToFlight = Map<String, Flight>();
  Map<String, Actor> airlineCodeToActor = Map<String, Actor>();

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<String, ContractEvent> contractEvents;
  Map<String, FlightSuretyEvent Function(List<dynamic> decodedData)>
      contractData;

  factory Prerequisites() {
    return _prerequisites;
  }

  Prerequisites._internal() {
    _prerequisitesReady = _createWorld();
  }

  Future get initializationDone => _prerequisitesReady;

  /// Public factory
  Future _createWorld() async {
    await loadContracts();
    await loadAccounts();
    setupActors();
    setupContractFunctions();
    setupContractEvents();
    await setupFlights();
  }

  Future<void> loadAccounts() async {
    String data = await rootBundle.loadString('assets/contracts/accounts.json');
    var jsonData = json.decode(data);
    accounts = Accounts.fromJson(jsonData);
  }

  Future<void> loadContracts() async {
    String data = await rootBundle.loadString('assets/contracts/config.json');
    var configMap = json.decode(data);
    configFile = ConfigFile.fromJson(configMap);

    appContractAddress =
        EthereumAddress.fromHex(configFile.localhost.appAddress);

    final appContractString = await rootBundle
        .loadString('assets/contracts/build/FlightSuretyApp.abi');

    appContract = DeployedContract(
        ContractAbi.fromJson(appContractString, 'FlightSuretyApp'),
        appContractAddress);

    dataContractAddress =
        EthereumAddress.fromHex(configFile.localhost.dataAddress);

    final dataContractString = await rootBundle
        .loadString('assets/contracts/build/FlightSuretyData.abi');

    dataContract = DeployedContract(
        ContractAbi.fromJson(dataContractString, 'FlightSuretyData'),
        appContractAddress);
  }

  Future<void> setupFlights() async {
    List<String> files = [
      'assets/data/airline_cx.json',
      'assets/data/airline_dl.json',
      'assets/data/airline_af.json',
      'assets/data/airline_ba.json',
      'assets/data/airline_nh.json',
    ];

    files.forEach((file) async {
      var raw = await rootBundle.loadString(file);
      ff.FlightFile flightFile = ff.FlightFile.fromRawJson(raw);
      flightFile.data.forEach((f) {
        EthereumAddress airlineAddress =
            airlineCodeToActor[f.airline.iata].address;
        Flight flight = Flight(
          airlineAddress: airlineAddress,
          airlineName: f.airline.name,
          airlineIata: f.airline.iata,
          arrivalIata: f.arrival.iata,
          departureIata: f.departure.iata,
          flightIata: f.flight.iata,
          scheduledArrival: f.arrival.scheduled,
          scheduledDeparture: f.departure.scheduled,
          arrivalAirportName: f.arrival.airport,
          departureAirportName: f.departure.airport,
          departureGate: f.departure.gate,
          arrivalGate: f.arrival.gate,
          status: 0,
          registered: false,
        );

        flightCodeToFlight[f.flight.iata] = flight;
      });
    });
  }

  void setupActors() {
    actorList = [];
    nameToActor = LinkedHashMap<String, Actor>();

    accounts.privateKeys.forEach((key, value) {
      EthereumAddress address = EthereumAddress.fromHex(key);
      EthPrivateKey privateKey = EthPrivateKey.fromHex(value);
      Actor actor = Actor(
          address: address,
          privateKey: privateKey,
          actorType: ActorType.Unassigned);
      actorList.add(actor);
    });

    actorList[0].actorType = ActorType.ContractOwner;
    actorList[0].actorName = 'Contract Owner';
    nameToActor['Contract Owner'] = actorList[0];

    int counter;

    List<String> airlineCodes = [
      'CX',
      'DL',
      'AF',
      'BA',
      'NH',
    ];

    counter = 0;
    actorList.sublist(1, 6).forEach((account) {
      account.actorType = ActorType.Airline;
      String name = appConstants.airlineNames.elementAt(counter);
      account.actorName = name;
      nameToActor[name] = account;
      airlineCodeToActor[airlineCodes[counter]] = account;
      counter++;
    });

    counter = 0;
    actorList.sublist(7, 12).forEach((account) {
      account.actorType = ActorType.Passenger;
      String name = appConstants.passengerNames.elementAt(counter);
      account.actorName = name;
      nameToActor[name] = account;
      counter++;
    });

    counter = 1;
    actorList.sublist(20, 40).forEach((account) {
      account.actorType = ActorType.Oracle;
      String name = 'Oracle $counter';
      account.actorName = name;
      nameToActor[name] = account;
      counter++;
    });

    counter = 1;
    actorList.sublist(41, 50).forEach((account) {
      account.actorType = ActorType.Unassigned;
      String name = 'Unassigned $counter';
      account.actorName = name;
      nameToActor[name] = account;
      counter++;
    });
  }

  void setupContractFunctions() {
    contractFunctions = Map<String, ContractFunction>();

    List<String> functionNames = [
      'contractOwner',
      'isOperational',
      'setOperationalStatus',
      'isAirlineRegistered',
      'isAirlineFunded',
      'nominateAirline',
      'registerAirline',
      'fundAirline',
      'isFlightRegistered',
      'registerFlight',
      'officialFlightStatus',
      'buyFlightInsurance',
      'fetchFlightStatus',
      'isOracleRegistered',
      'registerOracle',
      'getMyIndexes',
      'numberAirlineVotes',
    ];

    functionNames.forEach((key) {
      contractFunctions[key] = appContract.function(key);
    });
  }

  void setupContractEvents() {
    contractEvents = Map<String, ContractEvent>();

    List<String> eventNames = [
      'AirlineNominated',
      'AirlineRegistered',
      'AirlineFunded',
      'FlightRegistered',
      'InsurancePurchased',
      'InsurancePayout',
      'FlightStatusInfo',
      'OracleReport',
      'OracleRequest',
    ];

    eventNames.forEach((key) {
      contractEvents[key] = appContract.event(key);
    });

    contractData = {
      'AirlineNominated': (List<dynamic> decodedData) =>
          AirlineNominated(decodedData),
      'AirlineRegistered': (List<dynamic> decodedData) =>
          AirlineRegistered(decodedData),
      'AirlineFunded': (List<dynamic> decodedData) =>
          AirlineFunded(decodedData),
      'FlightRegistered': (List<dynamic> decodedData) =>
          FlightRegistered(decodedData),
      'InsurancePurchased': (List<dynamic> decodedData) =>
          InsurancePurchased(decodedData),
      'InsurancePayout': (List<dynamic> decodedData) =>
          InsurancePayout(decodedData),
      'FlightStatusInfo': (List<dynamic> decodedData) =>
          FlightStatusInfo(decodedData),
      'OracleReport': (List<dynamic> decodedData) => OracleReport(decodedData),
      'OracleRequest': (List<dynamic> decodedData) =>
          OracleRequest(decodedData),
    };
  }
}
