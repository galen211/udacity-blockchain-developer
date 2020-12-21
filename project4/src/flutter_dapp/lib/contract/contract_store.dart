import 'dart:collection';

import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/flight.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'contract_store.g.dart';

final App appConstants = App.settings;

class ContractStore = _ContractStore with _$ContractStore;

abstract class _ContractStore with Store {
  final accountStore = AccountStore();
  ContractService contracts;
  Prerequisites prerequisites;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Queue<FlightSuretyEvent> contractEvents;

  _ContractStore() {
    prerequisites = Prerequisites();
    appContract = prerequisites.appContract;
    appContractAddress = prerequisites.appContractAddress;
    dataContract = prerequisites.dataContract;
    dataContractAddress = prerequisites.dataContractAddress;
    contractFunctions = prerequisites.contractFunctions;
    contracts = ContractService();
  }

  @observable
  bool isTransactionPending = false;

  @observable
  ObservableList<String> sessionTransactionHistory =
      ObservableList<String>(); // could try substring highlight for log text

  @observable
  var accountBalance;

  @observable
  bool isAccountConnected = false;

  @observable
  bool isAppContractOperational;

  @observable
  ObservableMap<String, Actor> addressActors;

  @observable
  ObservableSet<String> airlines;

  @observable
  ObservableList<Flight> registeredFlights = ObservableList();

  @observable
  Flight selectedFlight;

  @observable
  FlightStatus selectedFlightStatus;

  @action
  Future<bool> isContractOperational() async {
    // List< status =
    //     await contracts.isOperational(accountStore.selectedActor.address);
  }

  @action
  void setPendingStatus(bool status) {
    isTransactionPending = status;
  }

  @action
  Future<void> toggleOperationalStatus() {}

  @action
  Future<void> setOperatingStatus() {}

  @action
  Future<void> registerAirline(String address) async {
    // final proceed = await warnNot(Actor.actorType.Airline);
    // if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.registerAirline(address);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> fundAirline(double amountEth) async {
    //final proceed = await warnNot(Actor.Airline);
    //if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.fundAirline(amountEth);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> registerFlight(Flight flight) async {
    //final proceed = await warnNot(Actor.Airline);
    //if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.registerFlight(flight);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> purchaseInsurance(double amountEth) async {
    // //final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.purchaseInsurance(amountEth);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> getFlights() async {
    //final proceed = await warnNot(Actor.Passenger);
    isTransactionPending = true;
    try {
      //registeredFlights =
      //    await service.getFlights().then((value) => value.asObservable());
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> checkFlightStatus() async {
    // final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //selectedFlightStatus = await service.checkFlightStatus(selectedFlight);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> queryAvailableBalance() async {
    // final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    //selectedAccountWithdrawableBalanceEth =
    //    await service.queryAvailableBalance(selectedAddress);
    isTransactionPending = false;
  }

  @action
  Future<void> withdrawAvailableBalance() async {
    // final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      await contracts.withdrawAvailableBalance();
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> selectAccount() {}

  void transactionCancelled() {
    //
  }

  // void initializeContract() {
  //   appContractAddress = '';
  // }

  // Future<bool> warnNot(Actor expectedActor) async {
  //   if (connectedAccountActor != expectedActor) {
  //     // require confirmSelection
  //   }
  //   return Future.value(true); // can proceed
  // }

  Future confirmSelection() {}
}
