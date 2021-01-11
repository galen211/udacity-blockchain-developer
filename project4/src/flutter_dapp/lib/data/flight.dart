import 'package:web3dart/web3dart.dart';

extension on Flight {}

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
  Airport departureAirport;
  Airport arrivalAirport;

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
  }) {
    this.departureAirport = Airport(departureIata, departureAirportName);
    this.arrivalAirport = Airport(arrivalIata, arrivalAirportName);
  }

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

  @override
  String toString() {
    return this.toJson().toString();
  }

  String statusDescription() {
    switch (status) {
      case 0:
        return 'Unknown';
        break;
      case 10:
        return 'On Time';
        break;
      case 20:
        return 'Late Due to Airline';
        break;
      case 30:
        return 'Late Due to Weather';
        break;
      case 40:
        return 'Late Due to Technical Problems';
        break;
      case 50:
        return 'Late Due to Other Causes';
        break;
      default:
        throw 'Unrecognized Flight Status Code: $status';
    }
  }

  void setDepartureAirport(Airport airport) {
    this.departureAirport = airport;
    this.departureIata = airport.airportIata;
    this.departureAirportName = airport.airportName;
  }

  void setArrivalAirport(Airport airport) {
    this.arrivalAirport = airport;
    this.arrivalIata = airport.airportIata;
    this.arrivalAirportName = airport.airportName;
  }
}

class Airport {
  String airportIata;
  String airportName;

  Airport(this.airportIata, this.airportName);

  String airportDescription() {
    return '$airportIata - $airportName';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Airport &&
        o.airportIata == airportIata &&
        o.airportName == airportName;
  }

  @override
  int get hashCode => airportIata.hashCode ^ airportName.hashCode;
}
