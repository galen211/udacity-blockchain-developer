// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FlightRegistrationStore on _FlightRegistrationStoreBase, Store {
  Computed<String> _$flightIataComputed;

  @override
  String get flightIata =>
      (_$flightIataComputed ??= Computed<String>(() => super.flightIata,
              name: '_FlightRegistrationStoreBase.flightIata'))
          .value;
  Computed<ActorStore> _$airlineComputed;

  @override
  ActorStore get airline =>
      (_$airlineComputed ??= Computed<ActorStore>(() => super.airline,
              name: '_FlightRegistrationStoreBase.airline'))
          .value;
  Computed<EthereumAddress> _$airlineAddressComputed;

  @override
  EthereumAddress get airlineAddress => (_$airlineAddressComputed ??=
          Computed<EthereumAddress>(() => super.airlineAddress,
              name: '_FlightRegistrationStoreBase.airlineAddress'))
      .value;
  Computed<String> _$airlineNameComputed;

  @override
  String get airlineName =>
      (_$airlineNameComputed ??= Computed<String>(() => super.airlineName,
              name: '_FlightRegistrationStoreBase.airlineName'))
          .value;
  Computed<int> _$departureTimeMillisComputed;

  @override
  int get departureTimeMillis => (_$departureTimeMillisComputed ??=
          Computed<int>(() => super.departureTimeMillis,
              name: '_FlightRegistrationStoreBase.departureTimeMillis'))
      .value;
  Computed<DateTime> _$scheduledDepartureComputed;

  @override
  DateTime get scheduledDeparture => (_$scheduledDepartureComputed ??=
          Computed<DateTime>(() => super.scheduledDeparture,
              name: '_FlightRegistrationStoreBase.scheduledDeparture'))
      .value;
  Computed<DateTime> _$scheduledArrivalComputed;

  @override
  DateTime get scheduledArrival => (_$scheduledArrivalComputed ??=
          Computed<DateTime>(() => super.scheduledArrival,
              name: '_FlightRegistrationStoreBase.scheduledArrival'))
      .value;
  Computed<bool> _$isValidSubmissionComputed;

  @override
  bool get isValidSubmission => (_$isValidSubmissionComputed ??= Computed<bool>(
          () => super.isValidSubmission,
          name: '_FlightRegistrationStoreBase.isValidSubmission'))
      .value;
  Computed<FlightStore> _$proposedFlightComputed;

  @override
  FlightStore get proposedFlight => (_$proposedFlightComputed ??=
          Computed<FlightStore>(() => super.proposedFlight,
              name: '_FlightRegistrationStoreBase.proposedFlight'))
      .value;

  final _$dataAtom = Atom(name: '_FlightRegistrationStoreBase.data');

  @override
  FlightDataStore get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(FlightDataStore value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  final _$accountAtom = Atom(name: '_FlightRegistrationStoreBase.account');

  @override
  AccountStore get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(AccountStore value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  final _$airlineIataAtom =
      Atom(name: '_FlightRegistrationStoreBase.airlineIata');

  @override
  String get airlineIata {
    _$airlineIataAtom.reportRead();
    return super.airlineIata;
  }

  @override
  set airlineIata(String value) {
    _$airlineIataAtom.reportWrite(value, super.airlineIata, () {
      super.airlineIata = value;
    });
  }

  final _$flightNumberAtom =
      Atom(name: '_FlightRegistrationStoreBase.flightNumber');

  @override
  String get flightNumber {
    _$flightNumberAtom.reportRead();
    return super.flightNumber;
  }

  @override
  set flightNumber(String value) {
    _$flightNumberAtom.reportWrite(value, super.flightNumber, () {
      super.flightNumber = value;
    });
  }

  final _$departureAirportAtom =
      Atom(name: '_FlightRegistrationStoreBase.departureAirport');

  @override
  Airport get departureAirport {
    _$departureAirportAtom.reportRead();
    return super.departureAirport;
  }

  @override
  set departureAirport(Airport value) {
    _$departureAirportAtom.reportWrite(value, super.departureAirport, () {
      super.departureAirport = value;
    });
  }

  final _$arrivalAirportAtom =
      Atom(name: '_FlightRegistrationStoreBase.arrivalAirport');

  @override
  Airport get arrivalAirport {
    _$arrivalAirportAtom.reportRead();
    return super.arrivalAirport;
  }

  @override
  set arrivalAirport(Airport value) {
    _$arrivalAirportAtom.reportWrite(value, super.arrivalAirport, () {
      super.arrivalAirport = value;
    });
  }

  final _$departureDateAtom =
      Atom(name: '_FlightRegistrationStoreBase.departureDate');

  @override
  DateTime get departureDate {
    _$departureDateAtom.reportRead();
    return super.departureDate;
  }

  @override
  set departureDate(DateTime value) {
    _$departureDateAtom.reportWrite(value, super.departureDate, () {
      super.departureDate = value;
    });
  }

  final _$departureTimeAtom =
      Atom(name: '_FlightRegistrationStoreBase.departureTime');

  @override
  TimeOfDay get departureTime {
    _$departureTimeAtom.reportRead();
    return super.departureTime;
  }

  @override
  set departureTime(TimeOfDay value) {
    _$departureTimeAtom.reportWrite(value, super.departureTime, () {
      super.departureTime = value;
    });
  }

  final _$isSubmittedAtom =
      Atom(name: '_FlightRegistrationStoreBase.isSubmitted');

  @override
  bool get isSubmitted {
    _$isSubmittedAtom.reportRead();
    return super.isSubmitted;
  }

  @override
  set isSubmitted(bool value) {
    _$isSubmittedAtom.reportWrite(value, super.isSubmitted, () {
      super.isSubmitted = value;
    });
  }

  final _$_FlightRegistrationStoreBaseActionController =
      ActionController(name: '_FlightRegistrationStoreBase');

  @override
  void clearForm() {
    final _$actionInfo = _$_FlightRegistrationStoreBaseActionController
        .startAction(name: '_FlightRegistrationStoreBase.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$_FlightRegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
account: ${account},
airlineIata: ${airlineIata},
flightNumber: ${flightNumber},
departureAirport: ${departureAirport},
arrivalAirport: ${arrivalAirport},
departureDate: ${departureDate},
departureTime: ${departureTime},
isSubmitted: ${isSubmitted},
flightIata: ${flightIata},
airline: ${airline},
airlineAddress: ${airlineAddress},
airlineName: ${airlineName},
departureTimeMillis: ${departureTimeMillis},
scheduledDeparture: ${scheduledDeparture},
scheduledArrival: ${scheduledArrival},
isValidSubmission: ${isValidSubmission},
proposedFlight: ${proposedFlight}
    ''';
  }
}
