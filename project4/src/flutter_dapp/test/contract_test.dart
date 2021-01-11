import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

final App app = App.settings;

Prerequisites prerequisites;

Map<String, Actor> actors;
Map<EventType, ContractEvent> contractEvents;

ContractService service;
StreamGroup streamGroup;
StreamSubscription streamSubscription;

void printEvent(FilterEvent event) {
  print(
      "EVENT Address: ${event.address.hex}, Event: ${event.topics.toString()}, Data: ${event.data}");
}

void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null; // required to make network calls

    prerequisites = Prerequisites();
    await prerequisites.initializationDone;

    actors = prerequisites.nameToActor;
    contractEvents = prerequisites.contractEvents;
    service = ContractService();
  });

  tearDownAll(() {
    service.client.dispose();
  });

  test("Print complete actor list", () {
    actors.entries.forEach((actor) {
      String address = actor.value.address.hex;
      print('${actor.key}, address:  $address');
    });
    print('--------------------------------');
  });

  test("Print test details", () async {
    Actor configOwner = actors[AppActor.contractOwner];
    print('App contract address: ${service.appContract.address.hex}');
    final owner = await service.getContractOwner(sender: configOwner.address);
    print('App contract owner: ${owner.hex}');
    print('Config contract owner: ${configOwner.address.hex}');
    int networkId = await service.client.getNetworkId();
    print("Network ID: $networkId");
    print('--------------------------------');
  });

  test("Setup streams", () async {
    streamGroup = StreamGroup();

    contractEvents.values.forEach((event) {
      Stream stream = service.registerStream(event);
      streamGroup.add(stream);
    });

    streamSubscription = streamGroup.stream.listen(
      (event) {
        printEvent(event);
      },
      onError: (e) {
        print("Error: ${e.toString()}");
      },
      onDone: () {
        print("Stream Done");
      },
      cancelOnError: false,
    );
  });

  test("Can deactivate operating status", () async {
    await service.setOperatingStatus(
        mode: false, credentials: actors[AppActor.contractOwner].privateKey);

    final result = await service.isOperational(
        sender: actors[AppActor.contractOwner].address);
    expect(result, false);
  });

  test("Can re-activate operating status", () async {
    await service.setOperatingStatus(
        mode: true, credentials: actors[AppActor.contractOwner].privateKey);
    final result = await service.isOperational(
        sender: actors[AppActor.contractOwner].address);
    expect(result, true);
  });

  test("First airline already registered?", () async {
    final result = await service.isAirlineRegistered(
        airlineAddress: actors[AppActor.airline1].address,
        sender: actors[AppActor.contractOwner].address);
    expect(result, true);
  });

  test("Airline not funded on launch", () async {
    final result = await service.isAirlineFunded(
        airlineAddress: actors[AppActor.airline1].address,
        sender: actors[AppActor.airline1].address);
    expect(result, false);
  });

  test("First airline funding succeeds ", () async {
    EtherAmount value = EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);
    await service.fundAirline(
        sender: actors[AppActor.airline1].address,
        credentials: actors[AppActor.airline1].privateKey,
        value: value);

    final result = await service.isAirlineFunded(
        airlineAddress: actors[AppActor.airline1].address,
        sender: actors[AppActor.airline1].address);
    expect(result, true);

    // service.client.dispose();
    // streamGroup.close();
  });

  test("Register airlines scenario", () async {
    app.airlineNames.forEach((name) async {
      final airline = actors[name].address;
      final credentials = actors[name].privateKey;

      await service.registerAirline(
          airlineAddress: airline, credentials: credentials);
    });

    // vote the 5th airline a second time
    await service.registerAirline(
        airlineAddress: actors[AppActor.airline5].address,
        credentials: actors[AppActor.airline2].privateKey);

    app.airlineNames.forEach((name) async {
      final airline = actors[name].address;
      final sender = airline;
      final r =
          service.isAirlineRegistered(airlineAddress: airline, sender: sender);
      expect(r, true);
    });
  });

  test("Fund airlines scenario", () async {
    EtherAmount value = EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);

    app.airlineNames.forEach((name) async {
      final airline = actors[name].address;
      final credential = actors[name].privateKey;
      await service.fundAirline(
          sender: airline, credentials: credential, value: value);
    });

    app.airlineNames.forEach((name) async {
      final airline = actors[name].address;
      final sender = airline;
      final r = await service.isAirlineFunded(
          airlineAddress: airline, sender: sender);
      expect(r, true);
    });
  });

  // test("Register flight succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Is flight registered succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Official flight status succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Buy flight insurance succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Fetch flight status succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Register Oracle succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Is Oracle registered succeeds", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });

  // test("Get my indexes succeeds for registered Oracle", () async {
  //   final result = await service.isOperational(actors[AppActor.airline1].address);
  //   expect(result, false);
  // });
}

// DeployedContract appContract;
// DeployedContract dataContract;
// EthereumAddress appContractAddress;
// EthereumAddress dataContractAddress;
// Map<String, ContractFunction> contractFunctions;
// Map<String, ContractEvent> contractEvents;

// appContract = prerequisites.appContract;
// dataContract = prerequisites.dataContract;
// appContractAddress = prerequisites.appContractAddress;
// dataContractAddress = prerequisites.dataContractAddress;
// contractFunctions = prerequisites.contractFunctions;
// contractEvents = prerequisites.contractEvents;

// test("Can send funds from airline 1 to contract owner", () async {
//   EtherAmount value = EtherAmount.fromUnitAndValue(EtherUnit.ether, 1);
//   await service.sendFunds(
//       actors[AppActor.contractOwner].address,
//       EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
//       actors[AppActor.airline1].privateKey);
// });
