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
  Map<EventType, ContractEvent> contractEvents;

  Map<String, Flight> flights;
  Map<String, Actor> airlines;
  List<Airport> airports;

  StreamGroup<FlightSuretyEvent> streamGroup;
  StreamSubscription<FlightSuretyEvent> subscription;

  List<ReactionDisposer> _disposers;

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
    airports = prerequisites.airports;

    service = ContractService();
    account = accountStore;

    setupValidations();
    setupStreams();
  }

  void dispose() {
    _disposers.forEach((disposer) {
      disposer();
    });
  }

  void setupValidations() {
    _disposers = [
      autorun((_) async {
        if (selectedAirlineChanged) {
          account.updateAirline(selectedAirline);
        }
      }),
      autorun((_) async {
        if (!isTransactionPending || actorType == ActorType.Airline) {
          await account.updateAirline(selectedActor);
        }
      }),
      autorun((_) async {
        if (!isTransactionPending || actorType == ActorType.Passenger) {
          await account.updatePassengerBalance(selectedActor);
        }
      }),
    ];
  }

  // contract variables
  @observable
  bool isAppOperational = true;

  @observable
  bool isTransactionPending = false;

  @observable
  ObservableStream eventStream;

  @observable
  ObservableList<FlightSuretyEvent> events =
      ObservableList<FlightSuretyEvent>();

  @observable
  bool updatePassenger;

  @observable
  bool updateAirline;

  // scenario variables
  @observable
  bool isAirlinesSetup = false;

  @observable
  bool allFlightsRegistered = false;

  // selected actor
  @computed
  bool get selectedAccountChanged => account.accountChanged;

  @observable
  EtherAmount withdrawablePayout = EtherAmount.zero();

  @observable
  EtherAmount addAirlineFundingAmount =
      EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  TimeOfDay selectedTime = TimeOfDay.now();

  @computed
  Actor get selectedActor => account.selectedActor;

  @computed
  Membership get selectedActorMembership => selectedActor.airlineMembership;

  @computed
  int get selectedActorVotes => selectedActor.airlineVotes;

  @computed
  EtherAmount get selectedActorFunding => selectedActor.airlineFunding;

  @computed
  ActorType get actorType => selectedActor.actorType;

  // selected airline
  @observable
  bool selectedAirlineChanged = false;

  @observable
  Actor selectedAirline = Actor.nullActor();

  @computed
  Membership get selectedAirlineMembership => selectedAirline.airlineMembership;

  @computed
  int get selectedAirlineVotes => selectedAirline.airlineVotes;

  @computed
  EtherAmount get selectedAirlineFunding => selectedAirline.airlineFunding;

  // flights
  @observable
  ObservableList<Flight> registeredFlights = ObservableList();

  @observable
  Flight selectedFlight = Flight.nullFlight();

  @observable
  Flight proposedFlight = Flight();

  @action
  List<DropdownMenuItem<Airport>> airportsDropdown() {
    List<DropdownMenuItem<Airport>> dropdown = <DropdownMenuItem<Airport>>[];
    airports.forEach((airport) {
      dropdown.add(
        DropdownMenuItem<Airport>(
          child: Text(airport.airportDescription()),
          value: airport,
        ),
      );
    });
    return dropdown;
  }

  @action
  List<DropdownMenuItem<Actor>> airlinesDropdown() {
    List<DropdownMenuItem<Actor>> dropdown = <DropdownMenuItem<Actor>>[];
    account.actors.entries
        .where((e) => (e.value.actorType == ActorType.Airline ||
            e.value.actorType == ActorType.Unassigned))
        .forEach((e) {
      dropdown.add(
        DropdownMenuItem<Actor>(
          child: Text(e.value.actorName),
          value: e.value,
        ),
      );
    });
    return dropdown;
  }

  @action
  String etherAmountText(EtherAmount amount) {
    return (amount.getValueInUnit(EtherUnit.finney) / 1000).toStringAsFixed(4);
  }

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
  Future<void> nominateAirline() async {
    try {
      await service.nominateAirline(
        airlineAddress: selectedAirline.address,
        sender: selectedActor.address,
        credentials: selectedActor.privateKey,
      );
    } catch (e) {
      debugPrint('Unable to nominate airline');
    }
  }

  @action
  Future<void> registerAirline() async {
    try {
      await service.registerFlight(
          flight: proposedFlight, credentials: selectedActor.privateKey);
    } catch (e) {
      debugPrint('Register airline failed with ${e.toString()}');
    }
  }

  @action
  Future<void> fundAirline() async {
    try {
      debugPrint(
          "Funding airline with amount: ${addAirlineFundingAmount.getInWei.toString()}");
      await service.fundAirline(
          sender: selectedActor.address,
          credentials: selectedActor.privateKey,
          value: addAirlineFundingAmount);
      await account.updateAirlineFunding(selectedActor);
      debugPrint("Funding succeeded");
    } catch (e) {
      debugPrint('Fund airline failed with ${e.toString()}');
    }
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
    } catch (e) {
      debugPrint('Purchase insurance failed with ${e.toString()}');
    }
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
  }

  @action
  Widget eventToWidget(BuildContext context, int index) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              events[index].eventType.eventName(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              width: 20,
            ),
            SelectableText(
              events[index].description(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }

  void setupStreams() {
    streamGroup = StreamGroup.broadcast();

    contractEvents.forEach((eventType, contractEvent) {
      Stream<FlightSuretyEvent> stream = service
          .registerStream(contractEvent)
          .map((List<dynamic> decodedData) {
        FlightSuretyEvent event = FlightSuretyEvent(eventType, decodedData);
        return event;
      });
      streamGroup.add(stream);
    });

    eventStream = streamGroup.stream.asObservable();

    subscription = streamGroup.stream.listen(
      (FlightSuretyEvent event) {
        events.add(event);
        debugPrint("Event: ${event.description()}");
      },
      onError: (e) {
        debugPrint("Stream Error ${e.toString()}");
      },
      onDone: () {
        debugPrint("Stream Done");
        subscription.cancel();
      },
      cancelOnError: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Setup Functions
  @action
  Future<void> registerAllFlights() async {
    List<Flight> flightsToRegister = flights.values.toList();

    await Future.forEach(flightsToRegister, (flight) async {
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
            'Registered flight ${flight.flightIata} Result: $isRegistered');
      } catch (e) {
        debugPrint(
            'Failed to register flight ${flight.flightIata} Error: ${e.toString()}');
      }
    });

    List<bool> isFlightRegistered = [];
    if (isFlightRegistered.every((e) => true)) {
      allFlightsRegistered = true;
      debugPrint('Flight setup succeeded!');
    } else {
      debugPrint('Flight setup failed!');
    }
  }

  @action
  Future<void> registerAllAirlines() async {
    Actor firstAirline = airlines.values.first;

    // must fund first airline
    debugPrint('---- Fund First Airline ----');
    try {
      await service.fundAirline(
          sender: firstAirline.address,
          credentials: firstAirline.privateKey,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
      bool result = await service.isAirlineFunded(
          airlineAddress: firstAirline.address, sender: firstAirline.address);
      debugPrint(
          'Funded ${firstAirline.actorName} Address: ${firstAirline.address.hex} \n Result: $result');
    } catch (e) {
      debugPrint(
          'Failed to fund ${firstAirline.actorName} Address: ${firstAirline.address.hex} Error: ${e.toString()}');
    }

    debugPrint('---- Registering Airlines ----');
    List<Actor> airlinesToRegister = airlines.values.toList().sublist(1);

    await Future.forEach(airlinesToRegister, (airline) async {
      try {
        await service.nominateAirline(
            airlineAddress: airline.address,
            sender: firstAirline.address,
            credentials: firstAirline.privateKey);
      } catch (e) {
        debugPrint(
            'Failed to nominate ${airline.actorName} Address: ${airline.address.hex}} Error: ${e.toString()}');
      }
    });

    await Future.forEach(airlinesToRegister, (airline) async {
      try {
        await service.registerAirline(
            airlineAddress: airline.address,
            sender: firstAirline.address,
            credentials: firstAirline.privateKey);
      } catch (e) {
        debugPrint(
            'Failed to register ${airline.actorName} Address: ${airline.address.hex}} Error: ${e.toString()}');
      }
    });

    await Future.forEach(airlinesToRegister.sublist(0, 3), (airline) async {
      try {
        await service.fundAirline(
            sender: airline.address,
            credentials: airline.privateKey,
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
      } catch (e) {
        debugPrint(
            'Failed to fund ${airline.actorName} Address: ${airline.address.hex} Error: ${e.toString()}');
      }
    });

    // Fifth airline
    Actor fifthAirline = airlinesToRegister.last;
    Actor secondAirline = airlinesToRegister.first;
    try {
      await service.registerAirline(
        airlineAddress: fifthAirline.address,
        sender: secondAirline.address,
        credentials: secondAirline.privateKey,
      );
    } catch (e) {
      debugPrint(
          'Failed to register ${fifthAirline.actorName} Address: ${fifthAirline.address.hex}} Error: ${e.toString()}');
    }

    try {
      await service.fundAirline(
        sender: fifthAirline.address,
        credentials: fifthAirline.privateKey,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10),
      );
    } catch (e) {
      debugPrint(
          'Failed to fund ${fifthAirline.actorName} Address: ${fifthAirline.address.hex} Error: ${e.toString()}');
    }

    List<bool> isFunded = [];
    await Future.forEach(airlinesToRegister, (airline) async {
      bool result = await service.isAirlineFunded(
          airlineAddress: airline.address, sender: airline.address);
      isFunded.add(result);
    });

    if (isFunded.every((e) => true)) {
      isAirlinesSetup = true;
      debugPrint('Airline consortium setup succeeded!');
    } else {
      debugPrint('Airline consortium setup failed!');
    }
  }
}
