// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContractStore on _ContractStore, Store {
  Computed<Actor> _$selectedActorComputed;

  @override
  Actor get selectedActor =>
      (_$selectedActorComputed ??= Computed<Actor>(() => super.selectedActor,
              name: '_ContractStore.selectedActor'))
          .value;

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

  final _$eventStreamAtom = Atom(name: '_ContractStore.eventStream');

  @override
  ObservableStream<dynamic> get eventStream {
    _$eventStreamAtom.reportRead();
    return super.eventStream;
  }

  @override
  set eventStream(ObservableStream<dynamic> value) {
    _$eventStreamAtom.reportWrite(value, super.eventStream, () {
      super.eventStream = value;
    });
  }

  final _$isAppOperationalAtom = Atom(name: '_ContractStore.isAppOperational');

  @override
  bool get isAppOperational {
    _$isAppOperationalAtom.reportRead();
    return super.isAppOperational;
  }

  @override
  set isAppOperational(bool value) {
    _$isAppOperationalAtom.reportWrite(value, super.isAppOperational, () {
      super.isAppOperational = value;
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

  final _$isAirlinesSetupAtom = Atom(name: '_ContractStore.isAirlinesSetup');

  @override
  bool get isAirlinesSetup {
    _$isAirlinesSetupAtom.reportRead();
    return super.isAirlinesSetup;
  }

  @override
  set isAirlinesSetup(bool value) {
    _$isAirlinesSetupAtom.reportWrite(value, super.isAirlinesSetup, () {
      super.isAirlinesSetup = value;
    });
  }

  final _$isFlightsRegisteredAtom =
      Atom(name: '_ContractStore.isFlightsRegistered');

  @override
  bool get isFlightsRegistered {
    _$isFlightsRegisteredAtom.reportRead();
    return super.isFlightsRegistered;
  }

  @override
  set isFlightsRegistered(bool value) {
    _$isFlightsRegisteredAtom.reportWrite(value, super.isFlightsRegistered, () {
      super.isFlightsRegistered = value;
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

  final _$proposedFlightAtom = Atom(name: '_ContractStore.proposedFlight');

  @override
  Flight get proposedFlight {
    _$proposedFlightAtom.reportRead();
    return super.proposedFlight;
  }

  @override
  set proposedFlight(Flight value) {
    _$proposedFlightAtom.reportWrite(value, super.proposedFlight, () {
      super.proposedFlight = value;
    });
  }

  final _$airlineFundingAmountAtom =
      Atom(name: '_ContractStore.airlineFundingAmount');

  @override
  EtherAmount get airlineFundingAmount {
    _$airlineFundingAmountAtom.reportRead();
    return super.airlineFundingAmount;
  }

  @override
  set airlineFundingAmount(EtherAmount value) {
    _$airlineFundingAmountAtom.reportWrite(value, super.airlineFundingAmount,
        () {
      super.airlineFundingAmount = value;
    });
  }

  final _$selectedDateAtom = Atom(name: '_ContractStore.selectedDate');

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  final _$selectedTimeAtom = Atom(name: '_ContractStore.selectedTime');

  @override
  TimeOfDay get selectedTime {
    _$selectedTimeAtom.reportRead();
    return super.selectedTime;
  }

  @override
  set selectedTime(TimeOfDay value) {
    _$selectedTimeAtom.reportWrite(value, super.selectedTime, () {
      super.selectedTime = value;
    });
  }

  final _$isContractOperationalAsyncAction =
      AsyncAction('_ContractStore.isContractOperational');

  @override
  Future<bool> isContractOperational() {
    return _$isContractOperationalAsyncAction
        .run(() => super.isContractOperational());
  }

  final _$setOperatingStatusAsyncAction =
      AsyncAction('_ContractStore.setOperatingStatus');

  @override
  Future<void> setOperatingStatus() {
    return _$setOperatingStatusAsyncAction
        .run(() => super.setOperatingStatus());
  }

  final _$registerAirlineAsyncAction =
      AsyncAction('_ContractStore.registerAirline');

  @override
  Future<void> registerAirline() {
    return _$registerAirlineAsyncAction.run(() => super.registerAirline());
  }

  final _$fundAirlineAsyncAction = AsyncAction('_ContractStore.fundAirline');

  @override
  Future<void> fundAirline() {
    return _$fundAirlineAsyncAction.run(() => super.fundAirline());
  }

  final _$registerFlightAsyncAction =
      AsyncAction('_ContractStore.registerFlight');

  @override
  Future<void> registerFlight() {
    return _$registerFlightAsyncAction.run(() => super.registerFlight());
  }

  final _$purchaseInsuranceAsyncAction =
      AsyncAction('_ContractStore.purchaseInsurance');

  @override
  Future<void> purchaseInsurance() {
    return _$purchaseInsuranceAsyncAction.run(() => super.purchaseInsurance());
  }

  final _$checkFlightStatusAsyncAction =
      AsyncAction('_ContractStore.checkFlightStatus');

  @override
  Future<void> checkFlightStatus() {
    return _$checkFlightStatusAsyncAction.run(() => super.checkFlightStatus());
  }

  final _$withdrawAvailableBalanceAsyncAction =
      AsyncAction('_ContractStore.withdrawAvailableBalance');

  @override
  Future<void> withdrawAvailableBalance() {
    return _$withdrawAvailableBalanceAsyncAction
        .run(() => super.withdrawAvailableBalance());
  }

  final _$registerAllFlightsAsyncAction =
      AsyncAction('_ContractStore.registerAllFlights');

  @override
  Future<void> registerAllFlights() {
    return _$registerAllFlightsAsyncAction
        .run(() => super.registerAllFlights());
  }

  final _$registerAllAirlinesAsyncAction =
      AsyncAction('_ContractStore.registerAllAirlines');

  @override
  Future<void> registerAllAirlines() {
    return _$registerAllAirlinesAsyncAction
        .run(() => super.registerAllAirlines());
  }

  final _$_ContractStoreActionController =
      ActionController(name: '_ContractStore');

  @override
  void getFlights() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.getFlights');
    try {
      return super.getFlights();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sessionTransactionHistory: ${sessionTransactionHistory},
eventStream: ${eventStream},
isAppOperational: ${isAppOperational},
isTransactionPending: ${isTransactionPending},
isAirlinesSetup: ${isAirlinesSetup},
isFlightsRegistered: ${isFlightsRegistered},
registeredFlights: ${registeredFlights},
selectedFlight: ${selectedFlight},
proposedFlight: ${proposedFlight},
airlineFundingAmount: ${airlineFundingAmount},
selectedDate: ${selectedDate},
selectedTime: ${selectedTime},
selectedActor: ${selectedActor}
    ''';
  }
}
