// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_data_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FlightDataStore on _FlightDataStoreBase, Store {
  Computed<ObservableList<ActorStore>> _$actorsComputed;

  @override
  ObservableList<ActorStore> get actors => (_$actorsComputed ??=
          Computed<ObservableList<ActorStore>>(() => super.actors,
              name: '_FlightDataStoreBase.actors'))
      .value;
  Computed<ObservableList<ActorStore>> _$consortiumAirlinesComputed;

  @override
  ObservableList<ActorStore> get consortiumAirlines =>
      (_$consortiumAirlinesComputed ??= Computed<ObservableList<ActorStore>>(
              () => super.consortiumAirlines,
              name: '_FlightDataStoreBase.consortiumAirlines'))
          .value;
  Computed<ObservableList<ActorStore>> _$airlinesComputed;

  @override
  ObservableList<ActorStore> get airlines => (_$airlinesComputed ??=
          Computed<ObservableList<ActorStore>>(() => super.airlines,
              name: '_FlightDataStoreBase.airlines'))
      .value;

  final _$accountsAtom = Atom(name: '_FlightDataStoreBase.accounts');

  @override
  ObservableMap<EthereumAddress, ActorStore> get accounts {
    _$accountsAtom.reportRead();
    return super.accounts;
  }

  @override
  set accounts(ObservableMap<EthereumAddress, ActorStore> value) {
    _$accountsAtom.reportWrite(value, super.accounts, () {
      super.accounts = value;
    });
  }

  final _$flightsAtom = Atom(name: '_FlightDataStoreBase.flights');

  @override
  ObservableMap<String, FlightStore> get flights {
    _$flightsAtom.reportRead();
    return super.flights;
  }

  @override
  set flights(ObservableMap<String, FlightStore> value) {
    _$flightsAtom.reportWrite(value, super.flights, () {
      super.flights = value;
    });
  }

  final _$airportsAtom = Atom(name: '_FlightDataStoreBase.airports');

  @override
  ObservableList<Airport> get airports {
    _$airportsAtom.reportRead();
    return super.airports;
  }

  @override
  set airports(ObservableList<Airport> value) {
    _$airportsAtom.reportWrite(value, super.airports, () {
      super.airports = value;
    });
  }

  final _$_FlightDataStoreBaseActionController =
      ActionController(name: '_FlightDataStoreBase');

  @override
  void addActor(ActorStore actor) {
    final _$actionInfo = _$_FlightDataStoreBaseActionController.startAction(
        name: '_FlightDataStoreBase.addActor');
    try {
      return super.addActor(actor);
    } finally {
      _$_FlightDataStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<DropdownMenuItem<Airport>> airportsDropdown() {
    final _$actionInfo = _$_FlightDataStoreBaseActionController.startAction(
        name: '_FlightDataStoreBase.airportsDropdown');
    try {
      return super.airportsDropdown();
    } finally {
      _$_FlightDataStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<DropdownMenuItem<ActorStore>> airlinesDropdown() {
    final _$actionInfo = _$_FlightDataStoreBaseActionController.startAction(
        name: '_FlightDataStoreBase.airlinesDropdown');
    try {
      return super.airlinesDropdown();
    } finally {
      _$_FlightDataStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<FlightStore> getFlights() {
    final _$actionInfo = _$_FlightDataStoreBaseActionController.startAction(
        name: '_FlightDataStoreBase.getFlights');
    try {
      return super.getFlights();
    } finally {
      _$_FlightDataStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
accounts: ${accounts},
flights: ${flights},
airports: ${airports},
actors: ${actors},
consortiumAirlines: ${consortiumAirlines},
airlines: ${airlines}
    ''';
  }
}
