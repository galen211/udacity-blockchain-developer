@TestOn('chrome')

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dapp/data/accounts.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/data/config.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/html.dart';

//import 'package:web_socket_channel/io.dart';

void main() async {
  Accounts accounts;
  Web3Client web3Client;
  String wsUrl = 'ws://localhost:8545';

  ConfigFile configFile;
  List<ActorStore> actors;

  DeployedContract appContract;
  DeployedContract dataContract;

  EthereumAddress appContractAddress;
  EthereumAddress dataContractAddress;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null; // required to make network calls

    String data = await rootBundle.loadString('assets/contracts/config.json');
    var configMap = json.decode(data);
    configFile = ConfigFile.fromJson(configMap);

    web3Client = Web3Client(configFile.localhost.url, http.Client(),
        socketConnector: () {
      return HtmlWebSocketChannel.connect(wsUrl).cast<String>();
      //return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
  });

  tearDown(() => web3Client.dispose());

  test("Can read default asset bundle", () async {
    print("appContractAddress: ${configFile.localhost.appAddress}");
    print("dataContractAddress: ${configFile.localhost.dataAddress}");
  });

  test("Can connect to Ethereum node", () async {
    var clientVersion = await web3Client.getClientVersion();
    print('$clientVersion');
  });

  test("Can retrieve accounts and private keys and check balances", () async {
    String data = await rootBundle.loadString('assets/contracts/accounts.json');
    var jsonData = json.decode(data);
    accounts = Accounts.fromJson(jsonData);
    accounts.privateKeys.forEach((key, value) async {
      var privateKey = EthPrivateKey.fromHex(value);
      EthereumAddress account = await privateKey.extractAddress();
      await web3Client.getBalance(account);
    });
    actors = setupActors(accounts);
  });

  test("The app and data contracts are both operational", () async {
    appContractAddress =
        EthereumAddress.fromHex(configFile.localhost.appAddress);

    dataContractAddress =
        EthereumAddress.fromHex(configFile.localhost.dataAddress);

    final appContractString = await rootBundle
        .loadString('assets/contracts/build/FlightSuretyApp.abi');
    final dataContractString = await rootBundle
        .loadString('assets/contracts/build/FlightSuretyData.abi');

    appContract = DeployedContract(
        ContractAbi.fromJson(appContractString, 'FlightSuretyApp'),
        appContractAddress);

    dataContract = DeployedContract(
        ContractAbi.fromJson(dataContractString, 'FightSuretyData'),
        dataContractAddress);

    final appIsOperational = appContract.function('isOperational');
    final dataIsOperational = dataContract.function('isOperational');

    ActorStore contractOwner = actors
        .firstWhere((actor) => actor.actorType == ActorType.ContractOwner);

    final isAppOperational = await web3Client.call(
        sender: contractOwner.address,
        contract: appContract,
        function: appIsOperational,
        params: []);

    expect(isAppOperational[0], true);

    final isDataOperational = await web3Client.call(
        sender: contractOwner.address,
        contract: dataContract,
        function: dataIsOperational,
        params: []);

    expect(isDataOperational[0], true);
  });
}

List<ActorStore> setupActors(Accounts accounts) {
  List<ActorStore> actors = [];
  accounts.privateKeys.forEach((key, value) {
    EthereumAddress address = EthereumAddress.fromHex(key);
    EthPrivateKey privateKey = EthPrivateKey.fromHex(value);
    ActorStore actor = ActorStore(
        address: address,
        privateKey: privateKey,
        actorType: ActorType.Unassigned);
    actors.add(actor);
  });

  actors[0].actorType = ActorType.ContractOwner;

  actors.sublist(1, 5).forEach((account) {
    account.actorType = ActorType.Airline;
  });

  actors.sublist(6, 10).forEach((account) {
    account.actorType = ActorType.Passenger;
  });

  actors.sublist(20, 40).forEach((account) {
    account.actorType = ActorType.Oracle;
  });
  return actors;
}
