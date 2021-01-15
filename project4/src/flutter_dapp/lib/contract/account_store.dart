import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/airlines.dart';
import 'package:flutter_dapp/components/oracles.dart';
import 'package:flutter_dapp/components/passengers.dart';
import 'package:flutter_dapp/components/scenario.dart';
import 'package:flutter_dapp/contract/contract_service.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'account_store.g.dart';

final App appConstants = App.settings;

class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
  Prerequisites prerequisites;
  Map<String, Actor> actors;
  List<ReactionDisposer> _disposers;
  ContractService service;

  _AccountStore(ContractService contractService) {
    prerequisites = Prerequisites();
    actors = prerequisites.nameToActor;
    service = contractService;
    setupValidations();
  }

  void dispose() {
    _disposers.forEach((disposer) {
      disposer();
    });
  }

  void setupValidations() {
    _disposers = [
      autorun((_) {
        if (!(selectedActor.actorType == ActorType.NotConnected)) {
          updateBalance(selectedActor);
        }
      }),
      autorun((_) {
        if (selectedActor.actorType == ActorType.Airline) {
          updateAirline(selectedActor);
        }
      }),
      autorun((_) {
        if (selectedActor.actorType == ActorType.Passenger) {
          updatePassengerBalance(selectedActor);
        }
      }),
    ];
  }

  @action
  Future<void> updateAirline(Actor actor) async {
    await Future.wait([
      updateAirlineFunding(actor),
      updateAirlineStatus(actor),
      updateAirlineVotes(actor),
    ]);
  }

  @action
  Future<void> updateAirlineFunding(Actor actor) async {
    EtherAmount fundingBalance = await service.amountAirlineFunds(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    actors[actor.actorName].airlineFunding = fundingBalance;
  }

  @action
  Future<void> updateAirlineVotes(Actor actor) async {
    int votes = await service.numberAirlineVotes(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    actors[actor.actorName].airlineVotes = votes;
  }

  @action
  Future<void> updateAirlineStatus(Actor actor) async {
    debugPrint('updateAirlineStatus: ${actor.actorName}');
    List<bool> futures = await Future.wait([
      service.isAirlineNominated(
        airlineAddress: selectedActor.address,
        sender: selectedActor.address,
      ),
      service.isAirlineRegistered(
        airlineAddress: selectedActor.address,
        sender: selectedActor.address,
      ),
      service.isAirlineFunded(
        airlineAddress: selectedActor.address,
        sender: selectedActor.address,
      ),
    ]);

    if (futures[0]) {
      actors[actor.actorName].airlineMembership = Membership.Funded;
    } else if (futures[1]) {
      actors[actor.actorName].airlineMembership = Membership.Registered;
    } else if (futures[0]) {
      actors[actor.actorName].airlineMembership = Membership.Nominated;
    } else {
      actors[actor.actorName].airlineMembership = Membership.Unknown;
    }
  }

  @action
  Future<void> updatePassengerBalance(Actor actor) async {
    debugPrint('updatePassengerBalance: ${actor.actorName}');
    EtherAmount payoutAmount = await service.passengerBalance(
      passenger: selectedActor.address,
      sender: selectedActor.address,
    );
    actors[actor.actorName].withdrawablePayout = payoutAmount;
  }

  @action
  Future<void> updateBalance(Actor actor) async {
    debugPrint('updateBalance: ${actor.actorName}');
    EtherAmount balance =
        await service.getAccountBalance(account: actor.address);
    actors[actor.actorName].accountBalance = balance;
  }

  @observable
  Actor selectedActor = Actor.nullActor();

  @observable
  int selectedPageIndex = 0;

  @observable
  bool accountChanged = false;

  @observable
  bool airlineChanged = false;

  final List<Widget> pages = [
    SetupPage(),
    AirlinePage(),
    PassengerPage(),
    OraclePage()
  ];

  @computed
  Widget get selectedPage => pages[selectedPageIndex];

  @observable
  EtherAmount selectedAccountBalance = EtherAmount.zero();

  @computed
  bool get isAccountConnected => selectedActor.actorName != 'Not Connected';

  @computed
  String get printedEtherAmount =>
      (selectedAccountBalance.getValueInUnit(EtherUnit.finney) / 1000)
          .toStringAsFixed(4);

  @computed
  String get selectedAccountDescription => selectedActor.actorName ==
          'Not Connected'
      ? 'Not Connected'
      : '${selectedActor.actorType.actorTypeName()}: ${selectedActor.address.hex.substring(0, 6)}...${selectedActor.address.hex.substring(35, 41)} | Balance: $printedEtherAmount ETH';

  @computed
  String get actorName => selectedActor.actorName;

  @action
  List<DropdownMenuItem<Actor>> accountsDropdown() {
    List<DropdownMenuItem<Actor>> dropdown = [];
    actors.forEach((key, value) {
      dropdown.add(DropdownMenuItem<Actor>(
        child: Text(key),
        value: value,
      ));
    });
    return dropdown;
  }
}
