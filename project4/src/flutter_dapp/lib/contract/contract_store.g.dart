// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContractStore on _ContractStore, Store {
  Computed<ActorType> _$actorTypeComputed;

  @override
  ActorType get actorType =>
      (_$actorTypeComputed ??= Computed<ActorType>(() => super.actorType,
              name: '_ContractStore.actorType'))
          .value;
  Computed<Actor> _$selectedActorComputed;

  @override
  Actor get selectedActor =>
      (_$selectedActorComputed ??= Computed<Actor>(() => super.selectedActor,
              name: '_ContractStore.selectedActor'))
          .value;
  Computed<String> _$airlineVotesStringComputed;

  @override
  String get airlineVotesString => (_$airlineVotesStringComputed ??=
          Computed<String>(() => super.airlineVotesString,
              name: '_ContractStore.airlineVotesString'))
      .value;
  Computed<String> _$airlineFundingStringComputed;

  @override
  String get airlineFundingString => (_$airlineFundingStringComputed ??=
          Computed<String>(() => super.airlineFundingString,
              name: '_ContractStore.airlineFundingString'))
      .value;

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

  final _$eventsAtom = Atom(name: '_ContractStore.events');

  @override
  ObservableList<FlightSuretyEvent> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<FlightSuretyEvent> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
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

  final _$selectedAirlineAtom = Atom(name: '_ContractStore.selectedAirline');

  @override
  Actor get selectedAirline {
    _$selectedAirlineAtom.reportRead();
    return super.selectedAirline;
  }

  @override
  set selectedAirline(Actor value) {
    _$selectedAirlineAtom.reportWrite(value, super.selectedAirline, () {
      super.selectedAirline = value;
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

  final _$addAirlineFundingAmountAtom =
      Atom(name: '_ContractStore.addAirlineFundingAmount');

  @override
  EtherAmount get addAirlineFundingAmount {
    _$addAirlineFundingAmountAtom.reportRead();
    return super.addAirlineFundingAmount;
  }

  @override
  set addAirlineFundingAmount(EtherAmount value) {
    _$addAirlineFundingAmountAtom
        .reportWrite(value, super.addAirlineFundingAmount, () {
      super.addAirlineFundingAmount = value;
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

  final _$withdrawablePayoutAtom =
      Atom(name: '_ContractStore.withdrawablePayout');

  @override
  EtherAmount get withdrawablePayout {
    _$withdrawablePayoutAtom.reportRead();
    return super.withdrawablePayout;
  }

  @override
  set withdrawablePayout(EtherAmount value) {
    _$withdrawablePayoutAtom.reportWrite(value, super.withdrawablePayout, () {
      super.withdrawablePayout = value;
    });
  }

  final _$airlineVotesAtom = Atom(name: '_ContractStore.airlineVotes');

  @override
  int get airlineVotes {
    _$airlineVotesAtom.reportRead();
    return super.airlineVotes;
  }

  @override
  set airlineVotes(int value) {
    _$airlineVotesAtom.reportWrite(value, super.airlineVotes, () {
      super.airlineVotes = value;
    });
  }

  final _$airlineFundingAtom = Atom(name: '_ContractStore.airlineFunding');

  @override
  EtherAmount get airlineFunding {
    _$airlineFundingAtom.reportRead();
    return super.airlineFunding;
  }

  @override
  set airlineFunding(EtherAmount value) {
    _$airlineFundingAtom.reportWrite(value, super.airlineFunding, () {
      super.airlineFunding = value;
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
  List<DropdownMenuItem<Airport>> airportsDropdown() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.airportsDropdown');
    try {
      return super.airportsDropdown();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<DropdownMenuItem<Actor>> airlinesDropdown() {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.airlinesDropdown');
    try {
      return super.airlinesDropdown();
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

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
  Widget eventToWidget(BuildContext context, int index) {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.eventToWidget');
    try {
      return super.eventToWidget(context, index);
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
eventStream: ${eventStream},
events: ${events},
isAppOperational: ${isAppOperational},
isTransactionPending: ${isTransactionPending},
isAirlinesSetup: ${isAirlinesSetup},
isFlightsRegistered: ${isFlightsRegistered},
selectedAirline: ${selectedAirline},
registeredFlights: ${registeredFlights},
selectedFlight: ${selectedFlight},
proposedFlight: ${proposedFlight},
addAirlineFundingAmount: ${addAirlineFundingAmount},
selectedDate: ${selectedDate},
selectedTime: ${selectedTime},
withdrawablePayout: ${withdrawablePayout},
airlineVotes: ${airlineVotes},
airlineFunding: ${airlineFunding},
actorType: ${actorType},
selectedActor: ${selectedActor},
airlineVotesString: ${airlineVotesString},
airlineFundingString: ${airlineFundingString}
    ''';
  }
}
