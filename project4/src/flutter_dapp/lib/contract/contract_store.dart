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
        if (account.accountChanged) {
          await account.updateAirlineFunding();
          airlineFunding = account.selectedActor.airlineFunding;
          await account.updateAirlineVotes();
          airlineVotes = account.selectedActor.airlineVotes;
          account.updateBalance(selectedActor);
        }
      }),
      autorun((_) async {
        if (!isTransactionPending || actorType == ActorType.Airline) {
          await account.updateAirlineFunding();
          airlineFunding = account.selectedActor.airlineFunding;
          await account.updateAirlineVotes();
          airlineVotes = account.selectedActor.airlineVotes;
          account.updateBalance(selectedActor);
          await account.updateAirlineStatus();
        }
      }),
      autorun((_) async {
        if (!isTransactionPending || actorType == ActorType.Passenger) {
          await account.updatePassengerBalance();
          withdrawablePayout = account.selectedActor.withdrawablePayout;
          account.updateBalance(selectedActor);
        }
      }),
    ];
  }

  @observable
  ObservableStream eventStream;

  @observable
  ObservableList<FlightSuretyEvent> events =
      ObservableList<FlightSuretyEvent>();

  @observable
  bool isAppOperational = true;

  @observable
  bool isTransactionPending = false;

  @observable
  bool isAirlinesSetup = false;

  @observable
  bool isFlightsRegistered = false;

  @observable
  Actor selectedAirline = Actor.nullActor();

  @computed
  ActorType get actorType => selectedActor.actorType;

  @observable
  ObservableList<Flight> registeredFlights = ObservableList();

  @observable
  Flight selectedFlight = Flight();

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

  @observable
  EtherAmount addAirlineFundingAmount =
      EtherAmount.fromUnitAndValue(EtherUnit.ether, 10);

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  TimeOfDay selectedTime = TimeOfDay.now();

  @computed
  Actor get selectedActor => account.selectedActor;

  @observable
  EtherAmount withdrawablePayout = EtherAmount.zero();

  @observable
  int airlineVotes = 0;

  @observable
  EtherAmount airlineFunding = EtherAmount.zero();

  @computed
  String get airlineVotesString => airlineVotes.toString();

  @computed
  String get airlineFundingString =>
      (airlineFunding.getValueInUnit(EtherUnit.finney) / 1000)
          .toStringAsFixed(4);

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
    } catch (e) {
      debugPrint('Register airline failed with ${e.message}');
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
      await account.updateAirlineFunding();
      debugPrint("Funding succeeded");
    } catch (e) {
      debugPrint('Fund airline failed with ${e.message}');
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
      debugPrint('Purchase insurance failed with ${e.message}');
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
      color: Colors.blueAccent,
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
          'Funded ${firstAirline.actorName} Address: ${firstAirline.address.hex} \n Result: $result');
    } catch (e) {
      debugPrint(
          'failed to fund ${firstAirline.actorName} Address: ${firstAirline.address.hex} \n Error: ${e.message}');
    }

    List<Actor> airlineList = airlines.values.toList();

    debugPrint('---- Registering Airlines ----');

    for (var i = 1; i < airlineList.length - 1; i++) {
      Actor airlineToRegister = airlineList[i];
      try {
        await service.nominateAirline(
            airlineAddress: airlineToRegister.address,
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

    debugPrint('---- Funding Airlines ----');

    for (var i = 1; i < airlineList.length - 1; i++) {
      try {
        await service.fundAirline(
            sender: airlineList[i].address,
            credentials: airlineList[i].privateKey,
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
        bool isFunded = await service.isAirlineFunded(
            airlineAddress: airlineList[i].address,
            sender: airlineList[i].address);
        airlineList[i].isAirlineFunded = isFunded;
        debugPrint(
            'Funded ${airlineList[i].actorName} Address: ${airlineList[i].address.hex} \n Result: $isFunded');
      } catch (e) {
        debugPrint(
            'Failed to fund ${airlineList[i].actorName} Address: ${airlineList[i].address.hex} \n Error: ${e.message}');
      }
    }

    debugPrint('---- Fifth Airline ----');
    Actor airlineToRegister = airlineList[4];
    Actor airlineFour = airlineList[3];
    Actor airlineThree = airlineList[2];

    try {
      await service.nominateAirline(
          airlineAddress: airlineToRegister.address,
          sender: airlineFour.address,
          credentials: airlineFour.privateKey);
    } catch (e) {
      debugPrint(
          'Failed to nominate fifth airline | Airline: ${airlineToRegister.address.hex} Error: ${e.message}');
    }

    try {
      await service.registerAirline(
          airlineAddress: airlineToRegister.address,
          sender: airlineFour.address,
          credentials: airlineFour.privateKey);
    } catch (e) {
      debugPrint(
          'Failed to register fifth airline - vote 1 | Airline: ${airlineToRegister.address.hex} Error: ${e.message}');
    }

    try {
      await service.registerAirline(
          airlineAddress: airlineToRegister.address,
          sender: airlineThree.address,
          credentials: airlineThree.privateKey);
    } catch (e) {
      debugPrint(
          'Failed to register fifth airline - vote 2 | Airline: ${airlineToRegister.address.hex} Error: ${e.message}');
    }

    bool result = await service.isAirlineRegistered(
        airlineAddress: airlineToRegister.address,
        sender: airlineToRegister.address);
    airlineToRegister.isAirlineRegistered = result;

    try {
      await service.fundAirline(
          sender: airlineToRegister.address,
          credentials: airlineToRegister.privateKey,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10));
      bool isFunded = await service.isAirlineFunded(
          airlineAddress: airlineToRegister.address,
          sender: airlineToRegister.address);
      airlineList[4].isAirlineFunded = isFunded;
    } catch (e) {
      debugPrint(
          'Failed funding and registering ${airlineList[4].actorName} Address: ${airlineList[4].address.hex} \n Error: ${e.message}');
    }
    isAirlinesSetup = true;
  }
}
