import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/account_store.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/contract_service.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/stores/flight_registration_store.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'contract_store.g.dart';

final App appConstants = App.settings;

class ContractStore = _ContractStore with _$ContractStore;

abstract class _ContractStore with Store {
  Prerequisites prerequisites;

  ContractService service;

  AccountStore _accountStore;
  FlightDataStore _dataStore;
  FlightRegistrationStore _registrationStore;

  List<ReactionDisposer> _disposers;

  EthereumAddress dataContractAddress;
  EthereumAddress appContractAddress;

  _ContractStore(AccountStore accountStore, FlightDataStore dataStore,
      FlightRegistrationStore registrationStore) {
    prerequisites = Prerequisites();

    dataContractAddress = prerequisites.dataContractAddress;
    appContractAddress = prerequisites.appContractAddress;

    service = ContractService();
    _accountStore = accountStore;
    _dataStore = dataStore;
    _registrationStore = registrationStore;

    flights = _dataStore.flights;
    airlines = _dataStore.airlines;
    airports = _dataStore.airports;
    accounts = _dataStore.accounts;

    setupValidations();
  }

  @observable
  ObservableMap<EthereumAddress, ActorStore> accounts;

  @observable
  ObservableMap<String, FlightStore> flights; // => data.flights;

  @observable
  ObservableList<ActorStore> airlines; // => data.airlines;

  @observable
  ObservableList<Airport> airports; // => data.airports;

  @computed
  ActorStore get selectedActor => _accountStore.selectedAccount;

  @computed
  FlightStore get proposedFlight => _registrationStore.proposedFlight;

  void dispose() {
    _disposers.forEach((disposer) {
      disposer();
    });
  }

  void setupValidations() {
    _disposers = [
      autorun((_) {
        _accountStore.updateAirline(selectedAirline);
      }),
      autorun((_) {
        _accountStore.updateAirline(selectedActor);
      }),
      autorun((_) {
        _accountStore.updatePassengerBalance(selectedActor);
      }),
      autorun((_) {
        _accountStore.updateBalance(selectedActor);
      }),
      autorun((_) {
        if (_registrationStore.isSubmitted) {
          updateFlightRegistration(proposedFlight);
          _registrationStore.clearForm();
        }
      }),
      autorun((_) {
        if (selectedFlight.registered) {
          updateFlightStatus(selectedFlight);
        }
      }),
    ];
  }

  Future<void> updateFlightRegistration(FlightStore flight) async {
    try {
      bool isRegistered = await service.isFlightRegistered(
          flight: flight, sender: selectedActor.address);
      flight.registered = isRegistered;
    } catch (e) {
      debugPrint('Unable to update flight registration');
    }
  }

  Future<void> updateFlightStatus(FlightStore flight) async {
    try {
      int code = await service.officialFlightStatus(
          flight: flight, sender: selectedActor.address);
      flight.updateFlightStatus(code);
    } catch (e) {
      debugPrint('Unable to update official flight status');
    }
  }

  // contract variables
  @observable
  bool isAppOperational = true;

  @observable
  bool isTransactionPending = false;

  // scenario variables
  @observable
  bool isAirlinesSetup = false;

  @observable
  bool allFlightsRegistered = false;

  // selected actor
  @computed
  bool get selectedAccountChanged => _accountStore.accountChanged;

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
  Membership get selectedActorMembership => selectedActor.airlineMembership;

  @computed
  int get selectedActorVotes => selectedActor.airlineVotes;

  @computed
  EtherAmount get selectedActorFunding => selectedActor.airlineFunding;

  @computed
  ActorType get actorType => selectedActor.actorType;

  @observable
  ActorStore selectedAirline = ActorStore();

  @observable
  FlightStore selectedFlight = FlightStore();

  @observable
  EtherAmount insuranceAmount =
      EtherAmount.fromUnitAndValue(EtherUnit.ether, 1);

  @observable
  EtherAmount withdrawalAmount = EtherAmount.zero();

  @action
  String etherAmountText(EtherAmount amount) {
    return (amount.getValueInUnit(EtherUnit.finney) / 1000).toStringAsFixed(4);
  }

  @computed
  List<FlightStore> get registeredFlights {
    return flights.values.where((flight) => flight.registered == true);
  }

  @action
  Future<void> setOperatingStatus() async {
    isTransactionPending = true;
    try {
      await service.setOperatingStatus(
        mode: !isAppOperational,
        credentials: selectedActor.privateKey,
      );
      bool isOperational =
          await service.isOperational(sender: selectedActor.address);
      isAppOperational = isOperational;
    } catch (e) {
      debugPrint('Unable to set operating status');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> nominateAirline() async {
    isTransactionPending = true;
    try {
      await service.nominateAirline(
        airlineAddress: selectedAirline.address,
        sender: selectedActor.address,
        credentials: selectedActor.privateKey,
      );
      selectedAirline.actorType = ActorType.Airline;
      await _accountStore.updateAirline(selectedAirline);
    } catch (e) {
      debugPrint('Unable to nominate airline');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> registerAirline() async {
    isTransactionPending = true;
    try {
      await service.registerAirline(
          airlineAddress: selectedAirline.address,
          sender: selectedActor.address,
          credentials: selectedActor.privateKey);
      await _accountStore.updateAirline(selectedAirline);
    } catch (e) {
      debugPrint('Register airline failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> fundAirline() async {
    isTransactionPending = true;
    try {
      debugPrint(
          "Funding airline with amount: ${addAirlineFundingAmount.getInWei.toString()}");
      await service.fundAirline(
          sender: selectedActor.address,
          credentials: selectedActor.privateKey,
          value: addAirlineFundingAmount);
      await _accountStore.updateAirline(selectedActor);
    } catch (e) {
      debugPrint('Fund airline failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> registerFlight() async {
    isTransactionPending = true;
    try {
      await service.registerFlight(
          flight: proposedFlight,
          sender: selectedActor.address,
          credentials: selectedActor.privateKey);
      _registrationStore.isSubmitted = true;
      flights[proposedFlight.flightIata] = proposedFlight;
    } catch (e) {
      debugPrint('Register flight failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> purchaseInsurance() async {
    isTransactionPending = true;

    try {
      await service.buyFlightInsurance(
          flight: selectedFlight,
          insuranceAmount: insuranceAmount,
          sender: selectedActor.address,
          credentials: selectedActor.privateKey);
    } catch (e) {
      debugPrint('Purchase insurance failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> checkFlightStatus() async {
    isTransactionPending = true;
    try {
      await service.fetchFlightStatus(
          flight: selectedFlight,
          sender: selectedActor.address,
          credentials: selectedActor.privateKey);
    } catch (e) {
      debugPrint('Check flight status failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  @action
  Future<void> withdrawAvailableBalance() async {
    isTransactionPending = true;

    try {
      await service.withdrawBalance(
          withdrawalAmount: withdrawalAmount,
          sender: selectedActor.address,
          credentials: selectedActor.privateKey);
    } catch (e) {
      debugPrint('Withdrawal failed with ${e.toString()}');
    }
    isTransactionPending = false;
  }

  // ---------------------------------------------------------------------------
  // Setup Functions
  @action
  Future<void> registerAllFlights() async {
    List<FlightStore> flightsToRegister = flights.values.toList();

    await Future.forEach(flightsToRegister, (flight) {
      EthereumAddress sender = accounts[flight.airlineAddress].address;
      EthPrivateKey credentials = accounts[flight.airlineAddress].privateKey;
      service.registerFlight(
        flight: flight,
        sender: sender,
        credentials: credentials,
      );
      debugPrint('Registering flight');
    });

    await Future.forEach(flightsToRegister, (flight) {
      updateFlightRegistration(flight);
    });

    if (flightsToRegister.every((flight) => flight.registered)) {
      allFlightsRegistered = true;
      debugPrint('Flight setup succeeded!');
    } else {
      debugPrint('Flight setup failed!');
    }
  }

  @action
  Future<void> registerAllAirlines() async {
    ActorStore firstAirline = airlines.first;

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
    List<ActorStore> airlinesToRegister =
        _dataStore.consortiumAirlines.sublist(1);

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
    ActorStore fifthAirline = airlinesToRegister.last;
    ActorStore secondAirline = airlinesToRegister.first;
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
