import 'package:web3dart/web3dart.dart';

enum FlightStatus {
  Unknown,
  LateAirline,
  LateWeather,
  LateTechnical,
  LateOther,
  OnTime,
}

extension StatusDescription on FlightStatus {
  String description() {
    switch (this) {
      case FlightStatus.Unknown:
        return 'Unknown';
        break;
      case FlightStatus.LateAirline:
        return 'Late Airline';
        break;
      case FlightStatus.LateWeather:
        return 'Late Weather';
        break;
      case FlightStatus.LateTechnical:
        return 'Late Technical';
        break;
      case FlightStatus.LateOther:
        return 'Late Other';
        break;
      case FlightStatus.OnTime:
        return 'On Time';
        break;
      default:
        return 'Invalid Flight Status';
        break;
    }
  }
}

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
  FlightStatus flightStatus;
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
    this.status = 0,
    this.flightStatus = FlightStatus.Unknown,
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
        'flightStatus': flightStatus.description(),
        'registered': registered,
      };

  @override
  String toString() {
    return this.toJson().toString();
  }

  void updateFlightStatus(int code) {
    this.status = code;
    switch (code) {
      case 0:
        this.flightStatus = FlightStatus.Unknown;
        break;
      case 10:
        this.flightStatus = FlightStatus.OnTime;
        break;
      case 20:
        this.flightStatus = FlightStatus.LateAirline;
        break;
      case 30:
        this.flightStatus = FlightStatus.LateWeather;
        break;
      case 40:
        this.flightStatus = FlightStatus.LateTechnical;
        break;
      case 50:
        this.flightStatus = FlightStatus.LateOther;
        break;
      default:
        throw 'Unknown Flight Status Code';
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

  static Flight nullFlight() {
    Flight flight = Flight(
      airlineAddress:
          EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      airlineName: '',
      airlineIata: '',
      flightIata: '',
      departureIata: '',
      arrivalIata: '',
      departureAirportName: '',
      arrivalAirportName: '',
      departureGate: '',
      arrivalGate: '',
      scheduledDeparture: DateTime.now(),
      scheduledArrival: DateTime.now(),
      status: 0,
      registered: false,
    );
    return flight;
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
