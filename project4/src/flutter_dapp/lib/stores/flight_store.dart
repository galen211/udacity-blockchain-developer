import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';
part 'flight_store.g.dart';

class FlightStore = _FlightStoreBase with _$FlightStore;

abstract class _FlightStoreBase with Store {
  @observable
  EthereumAddress airlineAddress;

  @observable
  String airlineName;

  @observable
  String airlineIata;

  @observable
  String flightIata;

  @observable
  String departureIata;

  @observable
  String arrivalIata;

  @observable
  String departureAirportName;

  @observable
  String arrivalAirportName;

  @observable
  String departureGate;

  @observable
  String arrivalGate;

  @observable
  DateTime scheduledDeparture;

  @observable
  DateTime scheduledArrival;

  @observable
  int status;

  @observable
  FlightStatus flightStatus;

  @observable
  bool registered;

  @observable
  Airport departureAirport;

  @observable
  Airport arrivalAirport;

  _FlightStoreBase({
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
    this.flightStatus,
    this.registered,
    this.departureGate,
    this.arrivalGate,
  }) {
    this.airlineAddress ??=
        EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
    this.airlineName ??= '';
    this.airlineIata ??= '';
    this.flightIata ??= '';
    this.departureIata ??= '';
    this.arrivalIata ??= '';
    this.departureAirportName ??= '';
    this.arrivalAirportName ??= '';
    this.scheduledDeparture ??= DateTime.now().add(Duration(days: 90));
    this.scheduledArrival ??= DateTime.now().add(Duration(days: 90, hours: 6));
    this.status ??= 0;
    this.flightStatus ??= FlightStatus.Unknown;
    this.registered ??= false;
    this.departureGate ??= '';
    this.arrivalGate ??= '';

    this.departureAirport =
        Airport(this.departureIata, this.departureAirportName);
    this.arrivalAirport = Airport(this.arrivalIata, this.arrivalAirportName);
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
}
