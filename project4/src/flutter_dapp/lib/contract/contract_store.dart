import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'contract_store.g.dart';

final App appConstants = App.settings;

class ContractStore = _ContractStore with _$ContractStore;

abstract class _ContractStore with Store {
  ContractService service;
  AccountStore account;

  Prerequisites prerequisites;

  DeployedContract appContract;
  EthereumAddress appContractAddress;

  DeployedContract dataContract;
  EthereumAddress dataContractAddress;

  Map<String, ContractFunction> contractFunctions;
  Map<String, ContractEvent> contractEvents;
  Map<String, FlightSuretyEvent Function(List<dynamic> decodedData)>
      contractData;

  Map<String, Flight> flights;
  Map<String, Actor> airlines;

  StreamGroup<FlightSuretyEvent> streamGroup;
  StreamSubscription<FlightSuretyEvent> subscription;

  _ContractStore(AccountStore accountStore) {
    prerequisites = Prerequisites();
    appContract = prerequisites.appContract;
    appContractAddress = prerequisites.appContractAddress;
    dataContract = prerequisites.dataContract;
    dataContractAddress = prerequisites.dataContractAddress;

    flights = prerequisites.flightCodeToFlight;
    airlines = prerequisites.airlineCodeToActor;

    contractFunctions = prerequisites.contractFunctions;
    contractEvents = prerequisites.contractEvents;
    contractData = prerequisites.contractData;

    service = ContractService();
    account = accountStore;

    //setupStreams();
  }

  @observable
  ObservableList<String> sessionTransactionHistory =
      ObservableList<String>(); // could try substring highlight for log text

  @observable
  ObservableStream eventStream;

  @observable
  bool isAppOperational = true;

  @observable
  bool isTransactionPending = false;

  @observable
  bool isAirlinesSetup = false;

  @observable
  bool isFlightsRegistered = false;

  @observable
  ObservableList<Flight> registeredFlights = ObservableList();

  @observable
  Flight selectedFlight = Flight();

  @observable
  Flight proposedFlight = Flight();

  @observable
  EtherAmount airlineFundingAmount = EtherAmount.zero();

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  TimeOfDay selectedTime = TimeOfDay.now();

  @computed
  Actor get selectedActor => account?.selectedActor;

  @action
  Future<bool> isContractOperational() async {
    try {
      bool isOperational =
          await service.isOperational(sender: selectedActor.address);
      isAppOperational = isOperational;
      return isAppOperational;
    } catch (e) {
      return isAppOperational;
    }
  }

  @action
  Future<void> setOperatingStatus() async {
    try {
      await service.setOperatingStatus(
        mode: !isAppOperational,
        credentials: selectedActor.privateKey,
      );
      bool isOperational =
          await service.isOperational(sender: selectedActor.address);
      isAppOperational = isOperational;
    } catch (e) {}
  }

  @action
  Future<void> registerAirline() async {
    try {
      await service.registerFlight(
          flight: proposedFlight, credentials: selectedActor.privateKey);
    } catch (e) {}
  }

  @action
  Future<void> fundAirline() async {
    try {
      await service.fundAirline(
          sender: selectedActor.address,
          credentials: selectedActor.privateKey,
          value: airlineFundingAmount);
    } catch (e) {}
  }

  @action
  Future<void> registerFlight() async {
    try {
      await service.registerFlight(
          flight: proposedFlight, credentials: selectedActor.privateKey);
    } catch (e) {}
  }

  @action
  Future<void> purchaseInsurance() async {
    try {
      //await service.purchaseInsurance();
    } catch (e) {}
  }

  @action
  void getFlights() {
    // flights.values.forEach((flight) async {
    //   bool isRegistered =
    // });
    // need to sometimes refresh whether flights registerd
    registeredFlights = flights.values
        // .where((flight) => flight.registered)
        .toList()
        .asObservable();
  }

  @action
  Future<void> checkFlightStatus() async {
    // final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();

    try {
      //selectedFlightStatus = await service.checkFlightStatus(selectedFlight);
    } catch (e) {}
  }

  @action
  Future<void> withdrawAvailableBalance() async {
    // final proceed = await warnNot(Actor.Passenger);
    // if (!proceed) return transactionCancelled();
    try {
      await service.withdrawAvailableBalance();
    } catch (e) {}
  }

  @action
  Future<void> registerAllFlights() async {
    flights.values.forEach((flight) async {
      EthereumAddress sender = airlines[flight.airlineIata].address;
      EthPrivateKey credentials = airlines[flight.airlineIata].privateKey;
      try {
        await service.registerFlight(
          flight: flight,
          sender: sender,
          credentials: credentials,
        );
        bool isRegistered = await service.isFlightRegistered(
            flight: flight, sender: flight.airlineAddress);
        flight.registered = isRegistered;
        debugPrint(
            'Flight registered! ${flight.airlineAddress.hex} ${flight.flightIata} ${flight.scheduledDeparture.millisecondsSinceEpoch}');
      } catch (e) {
        debugPrint(
            'Failed to register flight ${flight.flightIata} Error: ${e.toString()}');
      }
    });
    isFlightsRegistered = true;
  }

  @action
  Future<void> registerAllAirlines() async {
    Actor firstAirline = airlines.values.first;

    // must fund first airline
    debugPrint('---- First Airline ----');

    try {
      await service.fundAirline(
          sender: firstAirline.address,
          credentials: firstAirline.privateKey,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
      bool result = await service.isAirlineFunded(
          airlineAddress: firstAirline.address, sender: firstAirline.address);
      debugPrint(
          'Registered ${firstAirline.actorName} Address: ${firstAirline.address.hex} \n Result: $result');
    } catch (e) {
      debugPrint(
          'failed to fund ${firstAirline.actorName} Address: ${firstAirline.address.hex} \n Error: ${e.message}');
    }

    List<Actor> airlineList = airlines.values.toList();

    await Future.delayed(Duration(seconds: 2));
    debugPrint('---- Registering Airlines ----');

    for (var i = 1; i < airlineList.length; i++) {
      Actor airlineToRegister = airlineList[i];
      debugPrint(
          'Registering: ${airlineToRegister.actorName}, ${airlineToRegister.address.hex}');
      try {
        await service.nominateAirline(
            airlineAddress: airlineToRegister.address,
            airlineName: airlineToRegister.actorName,
            sender: firstAirline.address,
            credentials: firstAirline.privateKey);

        await service.registerAirline(
            airlineAddress: airlineToRegister.address,
            sender: firstAirline.address,
            credentials: firstAirline.privateKey);

        bool result = await service.isAirlineRegistered(
            airlineAddress: airlineToRegister.address,
            sender: selectedActor.address);
        airlineList[i].isAirlineRegistered = result;
        debugPrint(
            'Registered ${airlineList[i].actorName} Address: ${airlineList[i].address.hex} \n Result: $result');
      } catch (e) {
        debugPrint(
            'Failed to register ${airlineList[i].actorName} Address: ${airlineList[i].address.hex} \n Error: ${e.toString()}');
      }
    }

    // await Future.delayed(Duration(seconds: 4));
    // debugPrint('---- Funding Airlines ----');

    // for (var i = 1; i < airlineList.length - 1; i++) {
    //   try {
    //     await service.fundAirline(
    //         sender: airlineList[i].address,
    //         credentials: airlineList[i].privateKey,
    //         value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
    //     bool isFunded = await service.isAirlineFunded(
    //         airlineAddress: airlineList[i].address,
    //         sender: airlineList[i].address);
    //     airlineList[i].isAirlineFunded = isFunded;
    //   } catch (e) {
    //     debugPrint(
    //         'Failed to fund ${airlineList[i].actorName} Address: ${airlineList[i].address.hex} \n Error: ${e.message}');
    //   }
    // }

    // await Future.delayed(Duration(seconds: 4));
    // debugPrint('---- Fifth Airline ----');
    // // special case: 5th airline requires consensus
    // final result = await service.registerAirline(
    //     airlineAddress: airlineList[4].address, sender: airlineList[1].address);
    // airlineList[4].isAirlineRegistered = result;
    // try {
    //   await service.fundAirline(
    //       sender: airlineList[4].address,
    //       credentials: airlineList[4].privateKey,
    //       value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
    //   bool isFunded = await service.isAirlineFunded(
    //       airlineAddress: airlineList[4].address,
    //       sender: airlineList[4].address);
    //   airlineList[4].isAirlineFunded = isFunded;
    // } catch (e) {
    //   debugPrint(
    //       'Failed funding and registering ${airlineList[4].actorName} Address: ${airlineList[4].address.hex} \n Error: ${e.message}');
    // }

    isAirlinesSetup = true;
  }

  void setupStreams() {
    streamGroup = StreamGroup.broadcast();

    contractEvents.forEach((key, contractEvent) {
      Stream<FlightSuretyEvent> stream = service
          .registerStream(contractEvent)
          .map((List<dynamic> decodedData) {
        Function f = contractData[key];
        FlightSuretyEvent event = f(decodedData);
        return event;
      });
      streamGroup.add(stream);
    });

    eventStream = streamGroup.stream.asObservable();

    subscription = streamGroup.stream.listen(
      (event) {
        debugPrint("Event: ${event.toString()}");
      },
      onError: (e) {
        debugPrint("Stream Error");
      },
      onDone: () {
        debugPrint("Stream Done");
        subscription.cancel();
      },
      cancelOnError: false,
    );
  }
}
