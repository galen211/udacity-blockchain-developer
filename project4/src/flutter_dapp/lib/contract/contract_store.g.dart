// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContractStore on _ContractStore, Store {
  Computed<String> _$statusDescriptionComputed;

  @override
  String get statusDescription => (_$statusDescriptionComputed ??=
          Computed<String>(() => super.statusDescription,
              name: '_ContractStore.statusDescription'))
      .value;
  Computed<Actor> _$connectedAccountActorComputed;

  @override
  Actor get connectedAccountActor => (_$connectedAccountActorComputed ??=
          Computed<Actor>(() => super.connectedAccountActor,
              name: '_ContractStore.connectedAccountActor'))
      .value;

  final _$carouselControllerAtom =
      Atom(name: '_ContractStore.carouselController');

  @override
  CarouselController get carouselController {
    _$carouselControllerAtom.reportRead();
    return super.carouselController;
  }

  @override
  set carouselController(CarouselController value) {
    _$carouselControllerAtom.reportWrite(value, super.carouselController, () {
      super.carouselController = value;
    });
  }

  final _$selectedPageIndexAtom =
      Atom(name: '_ContractStore.selectedPageIndex');

  @override
  int get selectedPageIndex {
    _$selectedPageIndexAtom.reportRead();
    return super.selectedPageIndex;
  }

  @override
  set selectedPageIndex(int value) {
    _$selectedPageIndexAtom.reportWrite(value, super.selectedPageIndex, () {
      super.selectedPageIndex = value;
    });
  }

  final _$isTransactionPendingAtom =
      Atom(name: '_ContractStore.isTransactionPending');

  @override
  bool get isTransactionPending {
    _$isTransactionPendingAtom.reportRead();
    return super.isTransactionPending;
  }

  @override
  set isTransactionPending(bool value) {
    _$isTransactionPendingAtom.reportWrite(value, super.isTransactionPending,
        () {
      super.isTransactionPending = value;
    });
  }

  final _$sessionTransactionHistoryAtom =
      Atom(name: '_ContractStore.sessionTransactionHistory');

  @override
  ObservableList<String> get sessionTransactionHistory {
    _$sessionTransactionHistoryAtom.reportRead();
    return super.sessionTransactionHistory;
  }

  @override
  set sessionTransactionHistory(ObservableList<String> value) {
    _$sessionTransactionHistoryAtom
        .reportWrite(value, super.sessionTransactionHistory, () {
      super.sessionTransactionHistory = value;
    });
  }

  final _$chainIdAtom = Atom(name: '_ContractStore.chainId');

  @override
  String get chainId {
    _$chainIdAtom.reportRead();
    return super.chainId;
  }

  @override
  set chainId(String value) {
    _$chainIdAtom.reportWrite(value, super.chainId, () {
      super.chainId = value;
    });
  }

  final _$appContractAddressAtom =
      Atom(name: '_ContractStore.appContractAddress');

  @override
  String get appContractAddress {
    _$appContractAddressAtom.reportRead();
    return super.appContractAddress;
  }

  @override
  set appContractAddress(String value) {
    _$appContractAddressAtom.reportWrite(value, super.appContractAddress, () {
      super.appContractAddress = value;
    });
  }

  final _$connectedAccountAtom = Atom(name: '_ContractStore.connectedAccount');

  @override
  String get connectedAccount {
    _$connectedAccountAtom.reportRead();
    return super.connectedAccount;
  }

  @override
  set connectedAccount(String value) {
    _$connectedAccountAtom.reportWrite(value, super.connectedAccount, () {
      super.connectedAccount = value;
    });
  }

  final _$connectedAccountBalanceEthAtom =
      Atom(name: '_ContractStore.connectedAccountBalanceEth');

  @override
  double get connectedAccountBalanceEth {
    _$connectedAccountBalanceEthAtom.reportRead();
    return super.connectedAccountBalanceEth;
  }

  @override
  set connectedAccountBalanceEth(double value) {
    _$connectedAccountBalanceEthAtom
        .reportWrite(value, super.connectedAccountBalanceEth, () {
      super.connectedAccountBalanceEth = value;
    });
  }

  final _$selectedAddressAtom = Atom(name: '_ContractStore.selectedAddress');

  @override
  String get selectedAddress {
    _$selectedAddressAtom.reportRead();
    return super.selectedAddress;
  }

  @override
  set selectedAddress(String value) {
    _$selectedAddressAtom.reportWrite(value, super.selectedAddress, () {
      super.selectedAddress = value;
    });
  }

  final _$selectedAccountWithdrawableBalanceEthAtom =
      Atom(name: '_ContractStore.selectedAccountWithdrawableBalanceEth');

  @override
  double get selectedAccountWithdrawableBalanceEth {
    _$selectedAccountWithdrawableBalanceEthAtom.reportRead();
    return super.selectedAccountWithdrawableBalanceEth;
  }

  @override
  set selectedAccountWithdrawableBalanceEth(double value) {
    _$selectedAccountWithdrawableBalanceEthAtom
        .reportWrite(value, super.selectedAccountWithdrawableBalanceEth, () {
      super.selectedAccountWithdrawableBalanceEth = value;
    });
  }

  final _$metamaskAccountsAtom = Atom(name: '_ContractStore.metamaskAccounts');

  @override
  List<dynamic> get metamaskAccounts {
    _$metamaskAccountsAtom.reportRead();
    return super.metamaskAccounts;
  }

  @override
  set metamaskAccounts(List<dynamic> value) {
    _$metamaskAccountsAtom.reportWrite(value, super.metamaskAccounts, () {
      super.metamaskAccounts = value;
    });
  }

  final _$accountBalanceAtom = Atom(name: '_ContractStore.accountBalance');

  @override
  dynamic get accountBalance {
    _$accountBalanceAtom.reportRead();
    return super.accountBalance;
  }

  @override
  set accountBalance(dynamic value) {
    _$accountBalanceAtom.reportWrite(value, super.accountBalance, () {
      super.accountBalance = value;
    });
  }

  final _$isAccountConnectedAtom =
      Atom(name: '_ContractStore.isAccountConnected');

  @override
  bool get isAccountConnected {
    _$isAccountConnectedAtom.reportRead();
    return super.isAccountConnected;
  }

  @override
  set isAccountConnected(bool value) {
    _$isAccountConnectedAtom.reportWrite(value, super.isAccountConnected, () {
      super.isAccountConnected = value;
    });
  }

  final _$isAppContractOperationalAtom =
      Atom(name: '_ContractStore.isAppContractOperational');

  @override
  bool get isAppContractOperational {
    _$isAppContractOperationalAtom.reportRead();
    return super.isAppContractOperational;
  }

  @override
  set isAppContractOperational(bool value) {
    _$isAppContractOperationalAtom
        .reportWrite(value, super.isAppContractOperational, () {
      super.isAppContractOperational = value;
    });
  }

  final _$addressActorsAtom = Atom(name: '_ContractStore.addressActors');

  @override
  ObservableMap<String, Actor> get addressActors {
    _$addressActorsAtom.reportRead();
    return super.addressActors;
  }

  @override
  set addressActors(ObservableMap<String, Actor> value) {
    _$addressActorsAtom.reportWrite(value, super.addressActors, () {
      super.addressActors = value;
    });
  }

  final _$airlinesAtom = Atom(name: '_ContractStore.airlines');

  @override
  ObservableSet<String> get airlines {
    _$airlinesAtom.reportRead();
    return super.airlines;
  }

  @override
  set airlines(ObservableSet<String> value) {
    _$airlinesAtom.reportWrite(value, super.airlines, () {
      super.airlines = value;
    });
  }

  final _$registeredFlightsAtom =
      Atom(name: '_ContractStore.registeredFlights');

  @override
  ObservableList<Flight> get registeredFlights {
    _$registeredFlightsAtom.reportRead();
    return super.registeredFlights;
  }

  @override
  set registeredFlights(ObservableList<Flight> value) {
    _$registeredFlightsAtom.reportWrite(value, super.registeredFlights, () {
      super.registeredFlights = value;
    });
  }

  final _$selectedFlightAtom = Atom(name: '_ContractStore.selectedFlight');

  @override
  Flight get selectedFlight {
    _$selectedFlightAtom.reportRead();
    return super.selectedFlight;
  }

  @override
  set selectedFlight(Flight value) {
    _$selectedFlightAtom.reportWrite(value, super.selectedFlight, () {
      super.selectedFlight = value;
    });
  }

  final _$selectedFlightStatusAtom =
      Atom(name: '_ContractStore.selectedFlightStatus');

  @override
  FlightStatus get selectedFlightStatus {
    _$selectedFlightStatusAtom.reportRead();
    return super.selectedFlightStatus;
  }

  @override
  set selectedFlightStatus(FlightStatus value) {
    _$selectedFlightStatusAtom.reportWrite(value, super.selectedFlightStatus,
        () {
      super.selectedFlightStatus = value;
    });
  }

  final _$registerAirlineAsyncAction =
      AsyncAction('_ContractStore.registerAirline');

  @override
  Future<void> registerAirline(String address) {
    return _$registerAirlineAsyncAction
        .run(() => super.registerAirline(address));
  }

  final _$fundAirlineAsyncAction = AsyncAction('_ContractStore.fundAirline');

  @override
  Future<void> fundAirline(double amountEth) {
    return _$fundAirlineAsyncAction.run(() => super.fundAirline(amountEth));
  }

  final _$registerFlightAsyncAction =
      AsyncAction('_ContractStore.registerFlight');

  @override
  Future<void> registerFlight(Flight flight) {
    return _$registerFlightAsyncAction.run(() => super.registerFlight(flight));
  }

  final _$purchaseInsuranceAsyncAction =
      AsyncAction('_ContractStore.purchaseInsurance');

  @override
  Future<void> purchaseInsurance(double amountEth) {
    return _$purchaseInsuranceAsyncAction
        .run(() => super.purchaseInsurance(amountEth));
  }

  final _$getFlightsAsyncAction = AsyncAction('_ContractStore.getFlights');

  @override
  Future<void> getFlights() {
    return _$getFlightsAsyncAction.run(() => super.getFlights());
  }

  final _$checkFlightStatusAsyncAction =
      AsyncAction('_ContractStore.checkFlightStatus');

  @override
  Future<void> checkFlightStatus() {
    return _$checkFlightStatusAsyncAction.run(() => super.checkFlightStatus());
  }

  final _$queryAvailableBalanceAsyncAction =
      AsyncAction('_ContractStore.queryAvailableBalance');

  @override
  Future<void> queryAvailableBalance() {
    return _$queryAvailableBalanceAsyncAction
        .run(() => super.queryAvailableBalance());
  }

  final _$withdrawAvailableBalanceAsyncAction =
      AsyncAction('_ContractStore.withdrawAvailableBalance');

  @override
  Future<void> withdrawAvailableBalance() {
    return _$withdrawAvailableBalanceAsyncAction
        .run(() => super.withdrawAvailableBalance());
  }

  final _$_ContractStoreActionController =
      ActionController(name: '_ContractStore');

  @override
  void selectPage(int index) {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.selectPage');
    try {
      return super.selectPage(index);
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPendingStatus(bool status) {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.setPendingStatus');
    try {
      return super.setPendingStatus(status);
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carouselController: ${carouselController},
selectedPageIndex: ${selectedPageIndex},
isTransactionPending: ${isTransactionPending},
sessionTransactionHistory: ${sessionTransactionHistory},
chainId: ${chainId},
appContractAddress: ${appContractAddress},
connectedAccount: ${connectedAccount},
connectedAccountBalanceEth: ${connectedAccountBalanceEth},
selectedAddress: ${selectedAddress},
selectedAccountWithdrawableBalanceEth: ${selectedAccountWithdrawableBalanceEth},
metamaskAccounts: ${metamaskAccounts},
accountBalance: ${accountBalance},
isAccountConnected: ${isAccountConnected},
isAppContractOperational: ${isAppContractOperational},
addressActors: ${addressActors},
airlines: ${airlines},
registeredFlights: ${registeredFlights},
selectedFlight: ${selectedFlight},
selectedFlightStatus: ${selectedFlightStatus},
statusDescription: ${statusDescription},
connectedAccountActor: ${connectedAccountActor}
    ''';
  }
}
