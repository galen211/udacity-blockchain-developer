import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'flight_registration_store.g.dart';

class FlightRegistrationStore = _FlightRegistrationStoreBase
    with _$FlightRegistrationStore;

abstract class _FlightRegistrationStoreBase with Store {
  _FlightRegistrationStoreBase(AccountStore accountStore) {
    account = accountStore;
  }

  @observable
  FlightDataStore data;

  @observable
  AccountStore account;

  @observable
  String airlineIata;

  @observable
  String flightNumber;

  @observable
  Airport departureAirport;

  @observable
  Airport arrivalAirport;

  @observable
  DateTime departureDate;

  @observable
  TimeOfDay departureTime;

  @observable
  bool isSubmitted = false;

  @computed
  String get flightIata => '$airlineIata$flightNumber';

  @computed
  ActorStore get airline => account.selectedAccount;

  @computed
  EthereumAddress get airlineAddress => account.selectedAccount.address;

  @computed
  String get airlineName => account.selectedAccount.actorName;

  @computed
  int get departureTimeMillis => scheduledDeparture.millisecondsSinceEpoch;

  @computed
  DateTime get scheduledDeparture => departureDate
      .add(Duration(hours: departureTime.hour, minutes: departureTime.minute));

  @computed
  DateTime get scheduledArrival =>
      scheduledDeparture.add(Duration(hours: Random().nextInt(12)));

  @computed
  bool get isValidSubmission {
    return (airlineIata != null &&
        flightNumber != null &&
        departureAirport != null &&
        arrivalAirport != null &&
        departureDate != null &&
        departureTime != null);
  }

  @computed
  FlightStore get proposedFlight => FlightStore(
        airlineAddress: airlineAddress,
        airlineName: airlineName,
        airlineIata: airlineIata,
        flightIata: flightIata,
        departureIata: departureAirport.airportIata,
        arrivalIata: arrivalAirport.airportIata,
        departureAirportName: departureAirport.airportName,
        arrivalAirportName: arrivalAirport?.airportName,
        scheduledDeparture: scheduledDeparture,
        scheduledArrival: scheduledArrival,
        status: 0,
        flightStatus: FlightStatus.Unknown,
        registered: false,
        departureGate: 'Gate ${Random().nextInt(100)}',
        arrivalGate: 'Gate ${Random().nextInt(100)}',
      );

  @action
  void clearForm() {
    airlineIata = '';
    flightNumber = '';
    departureAirport = null;
    arrivalAirport = null;
    departureDate = null;
    departureTime = null;
    isSubmitted = false;
  }
}
