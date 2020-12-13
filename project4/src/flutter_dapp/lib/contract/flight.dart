import 'package:flutter/material.dart';

class Flight {
  String flightAirline;
  String flightName;
  DateTime departureTime;
  int flightStatus;
  bool selected;

  Flight(
      {@required this.flightAirline,
      @required this.flightName,
      @required this.departureTime,
      @required this.flightStatus,
      @required this.selected});
}
