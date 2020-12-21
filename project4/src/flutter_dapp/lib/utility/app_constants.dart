import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/utility/theme.dart';
import 'package:web3dart/web3dart.dart';

enum FlightStatus {
  Unknown,
  LateAirline,
  LateWeather,
  LateTechnical,
  LateOther
}

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

  final String contractOwner = 'Contract Owner';
  final String airline1 = 'Airline: Cathay Pacific';
  final String airline2 = 'Airline: Delta Airines';
  final String airline3 = 'Airline: Air France';
  final String airline4 = 'Airline: British Airways';
  final String airline5 = 'Airline: All Nippon Airlines';
  final String passenger1 = 'Passenger: Jibril Neville';
  final String passenger2 = 'Passenger: Xavier Whitehouse';
  final String passenger3 = 'Passenger: Brianna Carlson';
  final String passenger4 = 'Passenger: Lilah Felix';
  final String passenger5 = 'Passenger: Aizah Sosa';

  Map<int, String> statusCode = {
    0: 'Unknown',
    10: 'On Time',
    20: 'Late Due to Airline',
    30: 'Late Due to Weather',
    40: 'Late Due to Technical Problems',
    50: 'Late Due to Other Causes'
  };

  // assumes 5 airlines, 5 passengers
  Queue<String> get passengerNames => Queue.from([
        passenger1,
        passenger2,
        passenger3,
        passenger4,
        passenger5,
      ]);

  Queue<String> get airlineNames => Queue.from([
        airline1,
        airline2,
        airline3,
        airline4,
        airline5,
      ]);
}
