import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/flight.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:flutter_web3_provider/flutter_web3_provider.dart';
import 'package:mobx/mobx.dart';
import 'dart:js_util';

part 'contract_store.g.dart';

final App appConstants = App.settings;

class ContractStore = _ContractStore with _$ContractStore;

abstract class _ContractStore with Store {
  Web3Provider web3;
  ContractService service;

  _ContractStore() {
    //connectMetamask(); -> missing provider error
    service = ContractService();
  }

  @observable
  CarouselController carouselController = CarouselController();

  @observable
  int selectedPageIndex = 0;

  @action
  void selectPage(int index) {
    selectedPageIndex = index;
    carouselController.animateToPage(
      selectedPageIndex,
      duration: Duration(milliseconds: 500),
    );
  }

  @observable
  bool isTransactionPending = false;

  @observable
  ObservableList<String> sessionTransactionHistory =
      ObservableList<String>(); // could try substring highlight for log text

  @observable
  String chainId;

  @observable
  String appContractAddress;

  @observable
  String connectedAccount;

  @observable
  double connectedAccountBalanceEth;

  @observable
  String selectedAddress;

  @observable
  double selectedAccountWithdrawableBalanceEth;

  @observable
  List<dynamic> metamaskAccounts;

  @observable
  var accountBalance;

  @observable
  bool isAccountConnected = false;

  @computed
  String get statusDescription =>
      isAccountConnected ? '$connectedAccount' : 'Wallet Not Connected';

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

  @computed
  Actor get connectedAccountActor => addressActors[connectedAccount];

  @action
  void setPendingStatus(bool status) {
    isTransactionPending = status;
  }

  @action
  Future<void> registerAirline(String address) async {
    final proceed = await warnNot(Actor.Airline);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.registerAirline(address);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> fundAirline(double amountEth) async {
    final proceed = await warnNot(Actor.Airline);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.fundAirline(amountEth);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> registerFlight(Flight flight) async {
    final proceed = await warnNot(Actor.Airline);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //await service.registerFlight(flight);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> purchaseInsurance(double amountEth) async {
    final proceed = await warnNot(Actor.Passenger);
    if (!proceed) return transactionCancelled();
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
    final proceed = await warnNot(Actor.Passenger);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      //selectedFlightStatus = await service.checkFlightStatus(selectedFlight);
    } catch (e) {}
    isTransactionPending = false;
  }

  @action
  Future<void> queryAvailableBalance() async {
    final proceed = await warnNot(Actor.Passenger);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    //selectedAccountWithdrawableBalanceEth =
    //    await service.queryAvailableBalance(selectedAddress);
    isTransactionPending = false;
  }

  @action
  Future<void> withdrawAvailableBalance() async {
    final proceed = await warnNot(Actor.Passenger);
    if (!proceed) return transactionCancelled();
    isTransactionPending = true;
    try {
      await service.withdrawAvailableBalance();
    } catch (e) {}
    isTransactionPending = false;
  }

  void connectMetamask() async {
    try {
      web3 = getWeb3Provider();
      ethereum.autoRefreshOnNetworkChange = true;
      final Future<List<dynamic>> accountsFuture = promiseToFuture(
          ethereum.request(RequestParams(method: 'eth_requestAccounts')));
      metamaskAccounts = await accountsFuture;
      connectedAccount = ethereum.selectedAddress;
      final Future<dynamic> accountBalanceFuture =
          promiseToFuture(web3.getBalance(connectedAccount));
      accountBalance = await accountBalanceFuture;
      isAccountConnected = true;
    } on Exception catch (e) {
      debugPrint('Unable to get accounts from MetaMask: $e');
      return;
    }
  }

  void transactionCancelled() {
    //
  }

  void initializeContract() {
    appContractAddress = '';
  }

  Future<bool> warnNot(Actor expectedActor) async {
    if (connectedAccountActor != expectedActor) {
      // require confirmSelection
    }
    return Future.value(true); // can proceed
  }

  Future confirmSelection() {}
}
