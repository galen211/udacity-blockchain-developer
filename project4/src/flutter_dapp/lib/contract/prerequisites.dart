import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dapp/data/accounts.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/config.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:web3dart/web3dart.dart';

final App appConstants = App.settings;

class Prerequisites {
  Future _prerequisitesReady;
  static final Prerequisites _prerequisites = Prerequisites._internal();

  ConfigFile configFile;
  Map<String, Actor> actors;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<String, ContractEvent> contractEvents;

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
    setupContractFunctions();
    setupContractEvents();
  }

  Future<void> loadAccounts() async {
    String data = await rootBundle.loadString('assets/contracts/accounts.json');
    var jsonData = json.decode(data);
    Accounts accounts = Accounts.fromJson(jsonData);
    setupActors(accounts);
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

  void setupActors(Accounts accounts) {
    List<Actor> actorList = [];
    actors = LinkedHashMap<String, Actor>();

    accounts.privateKeys.forEach((key, value) {
      EthereumAddress address = EthereumAddress.fromHex(key);
      EthPrivateKey privateKey = EthPrivateKey.fromHex(value);
      Actor actor = Actor(address, privateKey, ActorType.Unassigned);
      actorList.add(actor);
    });

    actorList[0].actorType = ActorType.ContractOwner;
    actors['Contract Owner'] = actorList[0];

    actorList.sublist(1, 5).forEach((account) {
      account.actorType = ActorType.Airline;
      String name = appConstants.airlineNames.removeFirst();
      actors[name] = account;
    });

    actorList.sublist(6, 10).forEach((account) {
      account.actorType = ActorType.Passenger;
      String name = appConstants.passengerNames.removeFirst();
      actors[name] = account;
    });

    int counter = 1;
    actorList.sublist(20, 40).forEach((account) {
      account.actorType = ActorType.Oracle;
      actors['Oracle $counter'] = account;
      counter++;
    });
  }

  void setupContractFunctions() {
    contractFunctions = Map<String, ContractFunction>();

    List<String> functionNames = [
      'isOperational',
      'setOperationalStatus',
      'isAirlineRegistered',
      'isAirlineFunded',
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
  }
}
