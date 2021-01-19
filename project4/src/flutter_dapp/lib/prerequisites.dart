import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dapp/data/accounts.dart';
import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/data/config.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/data/flight_file.dart' as ff;
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:web3dart/web3dart.dart';

final App appConstants = App.settings;

class Prerequisites {
  Future _prerequisitesReady;

  static final Prerequisites _prerequisites = Prerequisites._internal();

  ConfigFile configFile;
  Accounts accounts;

  Map<String, FlightStore> flightMap = Map<String, FlightStore>();
  Map<EthereumAddress, ActorStore> actorMap;
  List<Airport> airportList;
  Map<String, EthereumAddress> airlineCodeToAddress;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<EventType, ContractEvent> contractEvents;
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
    setupAirports();
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

    await Future.wait(files.map((file) async {
      var raw = await rootBundle.loadString(file);
      ff.FlightFile flightFile = ff.FlightFile.fromRawJson(raw);
      flightFile.data.forEach((f) {
        EthereumAddress airlineAddress = airlineCodeToAddress[f.airline.iata];
        FlightStore flight = FlightStore(
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

        flightMap[f.flight.iata] = flight;
      });
    }));
  }

  void setupActors() {
    List<ActorStore> actorList = [];

    accounts.privateKeys.forEach((key, value) {
      EthereumAddress address = EthereumAddress.fromHex(key);
      EthPrivateKey privateKey = EthPrivateKey.fromHex(value);
      ActorStore actor = ActorStore(
        address: address,
        privateKey: privateKey,
        actorType: ActorType.Unassigned,
        airlineMembership: Membership.Nonmember,
        airlineFunding: EtherAmount.zero(),
        airlineVotes: 0,
        accountBalance: EtherAmount.zero(),
        withdrawablePayout: EtherAmount.zero(),
      );
      actorList.add(actor);
    });

    actorList[0].actorType = ActorType.ContractOwner;
    actorList[0].actorName = 'Contract Owner';

    int counter;

    airlineCodeToAddress = Map<String, EthereumAddress>();
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
      airlineCodeToAddress[airlineCodes[counter]] = account.address;
      counter++;
    });

    counter = 0;
    actorList.sublist(6, 20).forEach((account) {
      account.actorType = ActorType.Passenger;
      String name = appConstants.passengerNames.elementAt(counter);
      account.actorName = name;
      counter++;
    });

    counter = 1;
    actorList.sublist(20, 60).forEach((account) {
      account.actorType = ActorType.Unassigned;
      String name = 'Unassigned #$counter';
      account.actorName = name;
      counter++;
    });

    counter = 1;
    actorList.sublist(60, 100).forEach((account) {
      account.actorType = ActorType.Oracle;
      String name = 'Oracle #$counter';
      account.actorName = name;
      counter++;
    });

    actorMap = Map<EthereumAddress, ActorStore>();
    actorList.forEach((actor) {
      actorMap[actor.address] = actor;
    });

    ActorStore nullActor = ActorStore();
    actorMap[nullActor.address] = nullActor;
  }

  void setupContractFunctions() {
    contractFunctions = Map<String, ContractFunction>();

    List<String> functionNames = [
      // external
      'fundAirline',
      'buyFlightInsurance',
      'registerOracle',
      'officialFlightStatus',
      'nominateAirline',
      'registerAirline',
      'numberAirlineVotes',
      'isOperational',
      'amountAirlineFunds',
      'registerFlight',
      'setOperationalStatus',
      'isAirlineNominated',
      'isAirlineRegistered',
      'isAirlineFunded',
      'airlineMembership',
      'isPassengerInsured',
      'isPaidOut',
      'passengerBalance',
      'withdrawBalance',
      'getMyIndexes',
      'fetchFlightStatus',
      'submitOracleResponse',
      'MAX_INSURANCE_AMOUNT',
      'MIN_AIRLINE_FUNDING',
      'contractOwner',
      'dataContractAddress',
      'REGISTRATION_FEE',
      'isFlightRegistered',
      'isOracleRegistered',
    ];

    functionNames.forEach((key) {
      contractFunctions[key] = appContract.function(key);
    });
  }

  void setupContractEvents() {
    contractEvents = Map<EventType, ContractEvent>();

    for (EventType eventType in EventType.values) {
      contractEvents[eventType] = appContract.event(eventType.eventName());
    }
  }

  void setupAirports() {
    assert(flightMap.isNotEmpty);

    Set<Airport> airportSet = Set<Airport>();
    flightMap.values.forEach((flight) {
      airportSet.add(flight.departureAirport);
      airportSet.add(flight.arrivalAirport);
    });
    airportList = airportSet.toList();
    airportList.sort((a, b) => a.airportIata.compareTo(b.airportIata));
  }
}
