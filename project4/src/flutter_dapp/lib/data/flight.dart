import 'package:web3dart/web3dart.dart';

const Map<int, String> statusCode = {
  0: 'Unknown',
  10: 'On Time',
  20: 'Late Due to Airline',
  30: 'Late Due to Weather',
  40: 'Late Due to Technical Problems',
  50: 'Late Due to Other Causes'
};

class Flight {
  EthereumAddress airlineAddress;
  String airlineName;
  String airlineIata;
  String flightIata;
  String departureIata;
  String arrivalIata;
  String departureAirportName;
  String arrivalAirportName;
  String departureGate;
  String arrivalGate;
  DateTime scheduledDeparture;
  DateTime scheduledArrival;
  int status;
  bool registered;

  Flight({
    this.airlineAddress,
    this.airlineName,
    this.airlineIata,
    this.flightIata,
    this.departureIata,
    this.arrivalIata,
    this.departureAirportName,
    this.arrivalAirportName,
    this.scheduledDeparture,
    this.scheduledArrival,
    this.status,
    this.registered,
    this.departureGate,
    this.arrivalGate,
  });

  Map<String, dynamic> toJson() => {
        'airlineAddress': airlineAddress.hex,
        'airlineName': airlineName,
        'airlineIata': airlineIata,
        'flightIata': flightIata,
        'departureIata': departureIata,
        'arrivalIata': arrivalIata,
        'departureAirportName': departureAirportName,
        'arrivalAirportName': arrivalAirportName,
        'departureGate': departureGate,
        'arrivalGate': arrivalGate,
        'scheduledDeparture': scheduledDeparture.toIso8601String(),
        'scheduledArrival': scheduledArrival.toIso8601String(),
        'status': status,
        'registered': registered,
      };

  String getStatus() {
    return statusCode[this.status];
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
