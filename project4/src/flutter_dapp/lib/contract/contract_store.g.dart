// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContractStore on _ContractStore, Store {
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

  final _$isContractOperationalAsyncAction =
      AsyncAction('_ContractStore.isContractOperational');

  @override
  Future<bool> isContractOperational() {
    return _$isContractOperationalAsyncAction
        .run(() => super.isContractOperational());
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
  Future<void> toggleOperationalStatus() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.toggleOperationalStatus');
    try {
      return super.toggleOperationalStatus();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> setOperatingStatus() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.setOperatingStatus');
    try {
      return super.setOperatingStatus();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> selectAccount() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.selectAccount');
    try {
      return super.selectAccount();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isTransactionPending: ${isTransactionPending},
sessionTransactionHistory: ${sessionTransactionHistory},
accountBalance: ${accountBalance},
isAccountConnected: ${isAccountConnected},
isAppContractOperational: ${isAppContractOperational},
addressActors: ${addressActors},
airlines: ${airlines},
registeredFlights: ${registeredFlights},
selectedFlight: ${selectedFlight},
selectedFlightStatus: ${selectedFlightStatus}
    ''';
  }
}
