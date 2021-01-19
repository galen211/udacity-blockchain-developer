// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContractStore on _ContractStore, Store {
  Computed<ActorStore> _$selectedActorComputed;

  @override
  ActorStore get selectedActor => (_$selectedActorComputed ??=
          Computed<ActorStore>(() => super.selectedActor,
              name: '_ContractStore.selectedActor'))
      .value;
  Computed<FlightStore> _$proposedFlightComputed;

  @override
  FlightStore get proposedFlight => (_$proposedFlightComputed ??=
          Computed<FlightStore>(() => super.proposedFlight,
              name: '_ContractStore.proposedFlight'))
      .value;
  Computed<bool> _$selectedAccountChangedComputed;

  @override
  bool get selectedAccountChanged => (_$selectedAccountChangedComputed ??=
          Computed<bool>(() => super.selectedAccountChanged,
              name: '_ContractStore.selectedAccountChanged'))
      .value;
  Computed<Membership> _$selectedActorMembershipComputed;

  @override
  Membership get selectedActorMembership =>
      (_$selectedActorMembershipComputed ??= Computed<Membership>(
              () => super.selectedActorMembership,
              name: '_ContractStore.selectedActorMembership'))
          .value;
  Computed<int> _$selectedActorVotesComputed;

  @override
  int get selectedActorVotes => (_$selectedActorVotesComputed ??= Computed<int>(
          () => super.selectedActorVotes,
          name: '_ContractStore.selectedActorVotes'))
      .value;
  Computed<EtherAmount> _$selectedActorFundingComputed;

  @override
  EtherAmount get selectedActorFunding => (_$selectedActorFundingComputed ??=
          Computed<EtherAmount>(() => super.selectedActorFunding,
              name: '_ContractStore.selectedActorFunding'))
      .value;
  Computed<ActorType> _$actorTypeComputed;

  @override
  ActorType get actorType =>
      (_$actorTypeComputed ??= Computed<ActorType>(() => super.actorType,
              name: '_ContractStore.actorType'))
          .value;
  Computed<List<FlightStore>> _$registeredFlightsComputed;

  @override
  List<FlightStore> get registeredFlights => (_$registeredFlightsComputed ??=
          Computed<List<FlightStore>>(() => super.registeredFlights,
              name: '_ContractStore.registeredFlights'))
      .value;

  final _$accountsAtom = Atom(name: '_ContractStore.accounts');

  @override
  ObservableMap<EthereumAddress, ActorStore> get accounts {
    _$accountsAtom.reportRead();
    return super.accounts;
  }

  @override
  set accounts(ObservableMap<EthereumAddress, ActorStore> value) {
    _$accountsAtom.reportWrite(value, super.accounts, () {
      super.accounts = value;
    });
  }

  final _$flightsAtom = Atom(name: '_ContractStore.flights');

  @override
  ObservableMap<String, FlightStore> get flights {
    _$flightsAtom.reportRead();
    return super.flights;
  }

  @override
  set flights(ObservableMap<String, FlightStore> value) {
    _$flightsAtom.reportWrite(value, super.flights, () {
      super.flights = value;
    });
  }

  final _$airlinesAtom = Atom(name: '_ContractStore.airlines');

  @override
  ObservableList<ActorStore> get airlines {
    _$airlinesAtom.reportRead();
    return super.airlines;
  }

  @override
  set airlines(ObservableList<ActorStore> value) {
    _$airlinesAtom.reportWrite(value, super.airlines, () {
      super.airlines = value;
    });
  }

  final _$airportsAtom = Atom(name: '_ContractStore.airports');

  @override
  ObservableList<Airport> get airports {
    _$airportsAtom.reportRead();
    return super.airports;
  }

  @override
  set airports(ObservableList<Airport> value) {
    _$airportsAtom.reportWrite(value, super.airports, () {
      super.airports = value;
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

  final _$allFlightsRegisteredAtom =
      Atom(name: '_ContractStore.allFlightsRegistered');

  @override
  bool get allFlightsRegistered {
    _$allFlightsRegisteredAtom.reportRead();
    return super.allFlightsRegistered;
  }

  @override
  set allFlightsRegistered(bool value) {
    _$allFlightsRegisteredAtom.reportWrite(value, super.allFlightsRegistered,
        () {
      super.allFlightsRegistered = value;
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

  final _$selectedAirlineAtom = Atom(name: '_ContractStore.selectedAirline');

  @override
  ActorStore get selectedAirline {
    _$selectedAirlineAtom.reportRead();
    return super.selectedAirline;
  }

  @override
  set selectedAirline(ActorStore value) {
    _$selectedAirlineAtom.reportWrite(value, super.selectedAirline, () {
      super.selectedAirline = value;
    });
  }

  final _$selectedFlightAtom = Atom(name: '_ContractStore.selectedFlight');

  @override
  FlightStore get selectedFlight {
    _$selectedFlightAtom.reportRead();
    return super.selectedFlight;
  }

  @override
  set selectedFlight(FlightStore value) {
    _$selectedFlightAtom.reportWrite(value, super.selectedFlight, () {
      super.selectedFlight = value;
    });
  }

  final _$insuranceAmountAtom = Atom(name: '_ContractStore.insuranceAmount');

  @override
  EtherAmount get insuranceAmount {
    _$insuranceAmountAtom.reportRead();
    return super.insuranceAmount;
  }

  @override
  set insuranceAmount(EtherAmount value) {
    _$insuranceAmountAtom.reportWrite(value, super.insuranceAmount, () {
      super.insuranceAmount = value;
    });
  }

  final _$withdrawalAmountAtom = Atom(name: '_ContractStore.withdrawalAmount');

  @override
  EtherAmount get withdrawalAmount {
    _$withdrawalAmountAtom.reportRead();
    return super.withdrawalAmount;
  }

  @override
  set withdrawalAmount(EtherAmount value) {
    _$withdrawalAmountAtom.reportWrite(value, super.withdrawalAmount, () {
      super.withdrawalAmount = value;
    });
  }

  final _$setOperatingStatusAsyncAction =
      AsyncAction('_ContractStore.setOperatingStatus');

  @override
  Future<void> setOperatingStatus() {
    return _$setOperatingStatusAsyncAction
        .run(() => super.setOperatingStatus());
  }

  final _$nominateAirlineAsyncAction =
      AsyncAction('_ContractStore.nominateAirline');

  @override
  Future<void> nominateAirline() {
    return _$nominateAirlineAsyncAction.run(() => super.nominateAirline());
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
  String etherAmountText(EtherAmount amount) {
    final _$actionInfo = _$_ContractStoreActionController.startAction(
        name: '_ContractStore.etherAmountText');
    try {
      return super.etherAmountText(amount);
    } finally {
      _$_ContractStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
accounts: ${accounts},
flights: ${flights},
airlines: ${airlines},
airports: ${airports},
isAppOperational: ${isAppOperational},
isTransactionPending: ${isTransactionPending},
isAirlinesSetup: ${isAirlinesSetup},
allFlightsRegistered: ${allFlightsRegistered},
withdrawablePayout: ${withdrawablePayout},
addAirlineFundingAmount: ${addAirlineFundingAmount},
selectedDate: ${selectedDate},
selectedTime: ${selectedTime},
selectedAirline: ${selectedAirline},
selectedFlight: ${selectedFlight},
insuranceAmount: ${insuranceAmount},
withdrawalAmount: ${withdrawalAmount},
selectedActor: ${selectedActor},
proposedFlight: ${proposedFlight},
selectedAccountChanged: ${selectedAccountChanged},
selectedActorMembership: ${selectedActorMembership},
selectedActorVotes: ${selectedActorVotes},
selectedActorFunding: ${selectedActorFunding},
actorType: ${actorType},
registeredFlights: ${registeredFlights}
    ''';
  }
}
