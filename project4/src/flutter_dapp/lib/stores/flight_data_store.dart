import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

import 'actor_store.dart';

part 'flight_data_store.g.dart';

class FlightDataStore = _FlightDataStoreBase with _$FlightDataStore;

abstract class _FlightDataStoreBase with Store {
  Prerequisites prerequisites;

  _FlightDataStoreBase() {
    prerequisites = Prerequisites();

    accounts = prerequisites.actorMap.asObservable();
    flights = prerequisites.flightMap.asObservable();
    airports = prerequisites.airportList.asObservable();
  }

  @observable
  ObservableMap<EthereumAddress, ActorStore> accounts;

  @computed
  ObservableList<ActorStore> get actors => accounts.values
      .where((actor) => actor.actorType != ActorType.NotConnected)
      .toList()
      .asObservable();

  @computed
  ObservableList<ActorStore> get consortiumAirlines => accounts.values
      .where((actor) => (actor.actorType == ActorType.Airline))
      .toList()
      .asObservable();

  @computed
  ObservableList<ActorStore> get airlines => accounts.values
      .where((actor) => (actor.actorType == ActorType.Airline ||
          actor.actorType == ActorType.Unassigned))
      .toList()
      .asObservable();

  @observable
  ObservableMap<String, FlightStore> flights;

  @observable
  ObservableList<Airport> airports;

  @action
  void addActor(ActorStore actor) {
    accounts[actor.address] = actor;
  }

  @action
  List<DropdownMenuItem<Airport>> airportsDropdown() {
    List<DropdownMenuItem<Airport>> dropdown = <DropdownMenuItem<Airport>>[];
    airports.forEach((airport) {
      dropdown.add(
        DropdownMenuItem<Airport>(
          child: Text(airport.airportDescription),
          value: airport,
        ),
      );
    });
    return dropdown;
  }

  @action
  List<DropdownMenuItem<ActorStore>> airlinesDropdown() {
    List<DropdownMenuItem<ActorStore>> dropdown =
        <DropdownMenuItem<ActorStore>>[];
    accounts.values
        .where((actor) => (actor.actorType == ActorType.Airline ||
            actor.actorType == ActorType.Unassigned))
        .forEach((actor) {
      dropdown.add(
        DropdownMenuItem<ActorStore>(
          child: Text(actor.actorName),
          value: actor,
        ),
      );
    });
    return dropdown;
  }

  @action
  List<FlightStore> getFlights() {
    return flights.values.where((flight) => flight.registered).toList();
  }
}
