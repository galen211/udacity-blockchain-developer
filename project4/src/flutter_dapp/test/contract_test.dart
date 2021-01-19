import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/contract_service.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/stores/flight_registration_store.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

final App app = App.settings;

Prerequisites prerequisites;

FlightDataStore actors;
Map<String, ActorStore> airlines;
Map<String, FlightStore> flights;

Map<EventType, ContractEvent> contractEvents;

ContractService service;
StreamGroup<FlightSuretyEvent> streamGroup;
StreamSubscription<FlightSuretyEvent> streamSubscription;

AccountStore accountStore;
ContractStore contractStore;
FlightRegistrationStore registrationStore;
FlightDataStore dataStore;

void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null; // required to make network calls

    prerequisites = Prerequisites();
    await prerequisites.initializationDone;

    contractEvents = prerequisites.contractEvents;

    service = ContractService();

    accountStore = AccountStore(service, dataStore);
    contractStore = ContractStore(accountStore, dataStore, registrationStore);
  });

  tearDownAll(() {
    streamSubscription.cancel();
    service.client.dispose();
  });

  test("Print complete actor list", () {
    actors.accounts.values.forEach((actor) {
      String address = actor.address.hex;
      print('${actor.actorName}, address:  $address');
    });
    print('--------------------------------');
  });

  test("Print test details", () async {
    ActorStore configOwner = actors.accounts[AppActor.contractOwner];
    print('App contract address: ${service.appContract.address.hex}');
    final owner = await service.getContractOwner(sender: configOwner.address);
    print('App contract owner: ${owner.hex}');
    print('Config contract owner: ${configOwner.address.hex}');
    int networkId = await service.client.getNetworkId();
    print("Network ID: $networkId");
    print('--------------------------------');
  });

  test("Setup streams", () async {
    streamGroup = StreamGroup();

    contractEvents.forEach((eventType, contractEvent) {
      Stream<FlightSuretyEvent> stream = service
          .registerStream(contractEvent)
          .map((List<dynamic> decodedData) {
        FlightSuretyEvent event = FlightSuretyEvent(eventType, decodedData);
        return event;
      });
      streamGroup.add(stream);
    });

    streamSubscription = streamGroup.stream.listen(
      (FlightSuretyEvent event) {
        print(event.description());
      },
      onError: (e) {
        print("Error: ${e.toString()}");
      },
      onDone: () {
        print("Stream Done");
      },
      cancelOnError: false,
    );
  });

  test("Can deactivate operating status", () async {
    await service.setOperatingStatus(
        mode: false,
        credentials: actors.accounts[AppActor.contractOwner].privateKey);

    final result = await service.isOperational(
        sender: actors.accounts[AppActor.contractOwner].address);
    expect(result, false);
  });

  test("Can re-activate operating status", () async {
    await service.setOperatingStatus(
        mode: true,
        credentials: actors.accounts[AppActor.contractOwner].privateKey);
    final result = await service.isOperational(
        sender: actors.accounts[AppActor.contractOwner].address);
    expect(result, true);
  });

  test("First airline already registered?", () async {
    final result = await service.isAirlineRegistered(
        airlineAddress: actors.accounts[AppActor.airline1].address,
        sender: actors.accounts[AppActor.contractOwner].address);
    expect(result, true);
  });

  test("Airline not funded on launch", () async {
    final result = await service.isAirlineFunded(
        airlineAddress: actors.accounts[AppActor.airline1].address,
        sender: actors.accounts[AppActor.airline1].address);
    expect(result, false);
  });

  // test("First airline funding succeeds ", () async {
  //   EtherAmount value = EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);
  //   await service.fundAirline(
  //       sender: actors.accounts[AppActor.airline1].address,
  //       credentials: actors.accounts[AppActor.airline1].privateKey,
  //       value: value);

  //   final result = await service.isAirlineFunded(
  //       airlineAddress: actors.accounts[AppActor.airline1].address,
  //       sender: actors.accounts[AppActor.airline1].address);
  //   expect(result, true);
  // });

  test("Register all airlines scenario", () async {
    await contractStore.registerAllAirlines();

    List<ActorStore> airlineList = airlines.values.toList();

    await Future.forEach(airlineList, (airline) async {
      final isNominated = await service.isAirlineRegistered(
        airlineAddress: airline.address,
        sender: airline.address,
      );

      expect(isNominated, true);

      final isRegistered = await service.isAirlineRegistered(
        airlineAddress: airline.address,
        sender: airline.address,
      );

      expect(isRegistered, true);

      final isFunded = await service.isAirlineFunded(
        airlineAddress: airline.address,
        sender: airline.address,
      );

      expect(isFunded, true);
    });
  });

  test("Register all flights succeeds", () async {
    await contractStore.registerAllFlights();

    List<FlightStore> flightsToRegister = flights.values.toList();
    List<bool> isFlightRegistered = [];
    await Future.forEach(flightsToRegister, (flight) async {
      bool result = await service.isFlightRegistered(
        flight: flight,
        sender: flight.airlineAddress,
      );
      isFlightRegistered.add(result);
    });

    bool success = isFlightRegistered.every((e) => true);
    expect(success, true);
  });

  test("Purchase flight insurance succeeds", () async {
    final passenger = actors.accounts.values
        .firstWhere((actor) => actor.actorType == ActorType.Passenger);

    accountStore.selectedAccount = passenger;
    expect(accountStore.selectedAccount == contractStore.selectedActor, true);

    final flight = flights.values.first;
    contractStore.selectedFlight = flight;

    await contractStore.purchaseInsurance();

    final isPassengerInsured = await service.isPassengerInsured(
      flight: flight,
      passengerAddress: passenger.address,
      sender: passenger.address,
    );

    expect(isPassengerInsured, true);
  });

  test("Official flight status succeeds", () async {
    final flight = flights.values.first;
    contractStore.selectedFlight = flight;

    final result = await service.officialFlightStatus(
      flight: flight,
      sender: flight.airlineAddress,
    );

    flight.updateFlightStatus(result);
    expect(flight.flightStatus == FlightStatus.Unknown, true);
  });

  test("Fetch flight status succeeds", () async {
    final flight = flights.values.first;
    final passenger = actors.accounts.values
        .firstWhere((actor) => actor.actorType == ActorType.Passenger);

    await service.fetchFlightStatus(
      flight: flight,
      sender: passenger.address,
      credentials: passenger.privateKey,
    );

    final isPaidOut = await service.isPaidOut(
      flight: flight,
      sender: passenger.address,
    );

    expect(isPaidOut, false);

    final passengerBalance = await service.passengerBalance(
      passenger: passenger.address,
      sender: passenger.address,
    );

    expect(passengerBalance == EtherAmount.zero(), true);
  });
}
