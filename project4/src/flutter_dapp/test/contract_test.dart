import 'dart:io';

import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

final App app = App.settings;
Prerequisites prerequisites;

Map<String, Actor> actors;

ContractService service;

void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null; // required to make network calls

    prerequisites = Prerequisites();
    await prerequisites.initializationDone;

    actors = prerequisites.actors;
  });

  tearDown(() => service.client.dispose());

  test("Client version successful", () async {
    service = ContractService();
    final result = await service.client.getClientVersion();
    print(result);
  });

  test("Can deactivate operating status", () async {
    print("Sender: ${actors[app.contractOwner].address.hex}");
    int networkId = await service.client.getNetworkId();
    print("Network ID: $networkId");
    final result = await service.setOperatingStatus(
        false,
        EthPrivateKey.fromHex(
            '7407a0a98433a3443d61de96194ca85a1ed2270de3865079656908b52c1c4e77'));
    expect(result, false);
  });

  test("Can re-activate operating status", () async {
    print(await actors[app.contractOwner].privateKey.extractAddress());
    final result = await service.setOperatingStatus(
        true, actors[app.contractOwner].privateKey);
    expect(result, true);
  });

  test("Can check if contract is operational", () async {
    print(actors[app.contractOwner].address.hex);

    final result =
        await service.isOperational(actors[app.contractOwner].address);
    expect(result, true);
  });

  test("Is first airline registered?", () async {
    final result = await service.isAirlineRegistered(
        actors[app.airline1].address, actors[app.contractOwner].address);
    expect(result, true);
  });

  test("Is Airline funded successful", () async {
    final result = await service.isAirlineFunded(
        actors[app.airline1].address, actors[app.airline1].address);
    expect(result, false);
  });

  test("Fund airline succeeds", () async {
    EtherAmount value = EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);
    await service.fundAirline(
        actors[app.airline1].address, actors[app.airline1].privateKey, value);
  });

  // test("Register airline succeeds", () async {
  //   final result = await service.registerAirline(
  //       actors[app.airline2].address, actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Register flight succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Is flight registered succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Official flight status succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Buy flight insurance succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Fetch flight status succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Register Oracle succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Is Oracle registered succeeds", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
  //   expect(result, false);
  // });

  // test("Get my indexes succeeds for registered Oracle", () async {
  //   final result = await service.isOperational(actors[app.airline1].address);
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
