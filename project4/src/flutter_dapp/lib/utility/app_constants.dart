import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_dapp/utility/theme.dart';

enum ContractStatus { Paused, Operational }

class App {
  String appId;

  // Singleton declaration
  static final App _singleton = new App._internal();

  factory App(String appId) {
    _singleton.appId = appId;
    return _singleton;
  }

  App._internal();

  static App get settings => _singleton;

  String get appBarTitleText => 'Flight Surety';

  String get ethRpcServer => 'http://localhost:8545';
  String get wsUrl => 'ws://localhost:8545';

  ThemeData get theme => FlightSuretyTheme().theme;
  AssetImage get backgroundImage => AssetImage("assets/images/flight.jpg");

  // assumes 5 airlines, 5 passengers
  List<String> get passengerNames => List.from([
        AppActor.passenger1,
        AppActor.passenger2,
        AppActor.passenger3,
        AppActor.passenger4,
        AppActor.passenger5,
      ]);

  List<String> get airlineNames => List.from([
        AppActor.airline1,
        AppActor.airline2,
        AppActor.airline3,
        AppActor.airline4,
        AppActor.airline5,
      ]);
}

class AppActor {
  static String get contractOwner => 'Contract Owner';
  static String get airline1 => 'Cathay Pacific';
  static String get airline2 => 'Delta Airines';
  static String get airline3 => 'Air France';
  static String get airline4 => 'British Airways';
  static String get airline5 => 'All Nippon Airways';
  static String get passenger1 => 'Galen Simmons';
  static String get passenger2 => 'John Whitehouse';
  static String get passenger3 => 'Helene Seydoux';
  static String get passenger4 => 'Lilah Gerard';
  static String get passenger5 => 'Julie Waldmann';
}

// contract event names
class AppEvent {
  static String get airlineNominated => 'AirlineNominated';
  static String get airlineRegistered => 'AirlineRegistered';
  static String get airlineFunded => 'AirlineFunded';
  static String get flightRegistered => 'FlightRegistered';
  static String get insurancePurchased => 'InsurancePurchased';
  static String get insurancePayout => 'InsurancePayout';
  static String get flightStatusInfo => 'FlightStatusInfo';
  static String get oracleReport => 'OracleReport';
  static String get oracleRequest => 'OracleRequest';
}

class AppFlights {
  static final AppFlights _instance = AppFlights._internal();

  List<Flight> flights;

  factory AppFlights() {
    return _instance;
  }

  AppFlights._internal();
}
