import 'package:flutter/services.dart';
import 'package:flutter_dapp/data/flight_file.dart' as File;
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/credentials.dart';

void main() async {
  String rawData;
  File.FlightFile file;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    rawData = await rootBundle.loadString('assets/data/airline_af.json');
    file = File.FlightFile.fromRawJson(rawData);
  });

  test("Put flights into order", () {
    List<FlightStore> flightList = [];

    file.data.forEach((f) {
      FlightStore flight = FlightStore(
        airlineAddress: EthereumAddress.fromHex(
            '0x197128a71474fad3a82cf639ec427fd285f561eb'),
        airlineName: f.airline.name,
        arrivalIata: f.arrival.iata,
        departureIata: f.departure.iata,
        flightIata: f.flight.iata,
        scheduledArrival: f.arrival.scheduled,
        scheduledDeparture: f.departure.scheduled,
        arrivalAirportName: f.arrival.airport,
        departureAirportName: f.departure.airport,
        departureGate: f.departure.gate,
        arrivalGate: f.arrival.gate,
        status: 0,
        registered: false,
      );

      flightList.add(flight);
    });

    flightList.forEach((element) {
      print(element.toString());
    });
  });
}
