import 'package:flutter/material.dart';
import 'package:flutter_dapp/utility/theme.dart';

enum Actor { ContractOwner, Airline, Passenger, Oracle }
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

  // advice from the student
  //

  // priorities -> 1) connect to metamask, 2) create static layout of screens, 3) connect to contracts

  // actions:
  // Get AppContract Address, Get AppContract Status, Set AppContract Status
  // Get DataContract Status, Set DataContract Status

  // Contract Administration
  // Airlines: Register Airline, Fund Airline, Register New Flight
  // Passenger: Get Flights, Buy Insurance
  // Oracles: Check Flight Status, Withdraw
  // Transaction History: Event Log

  // divider between list items
  // use snackbar to log events?
  // use circular progress indicator during transactions / also linear progress indicator
  // use data table for flights

  static App get settings => _singleton;

  String get appBarTitleText => 'Flight Surety';

  String get ethRpcServer => 'http://127.0.0.1:8545';

  ThemeData get theme => FlightSuretyTheme().theme;
  AssetImage get backgroundImage => AssetImage("assets/images/flight.jpg");

  final EdgeInsets _formContainerEdgeInsets = EdgeInsets.all(16.0);
  //final double _formDefaultItemSpacer = 8.0;
  EdgeInsets get formContainerEdgeInsets => _formContainerEdgeInsets;

  Map<int, String> statusCode = {
    0: 'Unknown',
    10: 'On Time',
    20: 'Late Due to Airline',
    30: 'Late Due to Weather',
    40: 'Late Due to Technical Problems',
    50: 'Late Due to Other Causes'
  };
}
