import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
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

  @observable
  Actor selectedActor = Actor.nullActor();

  @observable
  int selectedPageIndex = 0;

  @observable
  bool accountChanged = false;

  @observable
  CarouselController carouselController = CarouselController();

  @action
  void selectPage(int index) {
    selectedPageIndex = index;
    carouselController.animateToPage(
      selectedPageIndex,
      duration: Duration(milliseconds: 500),
    );
  }

  @observable
  EtherAmount selectedAccountBalance = EtherAmount.zero();

  @computed
  bool get isAccountConnected => selectedActor.actorName != 'Not Connected';

  @computed
  String get printedEtherAmount =>
      (selectedAccountBalance.getValueInUnit(EtherUnit.finney) / 1000)
          .toStringAsFixed(4);

  void dispose() {
    _disposers.forEach((disposer) {
      disposer();
    });
  }

  void setupValidations() {
    _disposers = [
      autorun((_) => updateBalance(selectedActor)),
      autorun((_) {
        if (selectedActor.actorType == ActorType.Airline) {
          updateAirlineFunding();
          updateAirlineVotes();
        }
      }),
      autorun((_) {
        if (selectedActor.actorType == ActorType.Passenger) {
          updatePassengerBalance();
        }
      }),
    ];
  }

  @action
  Future<void> updateAirlineFunding() async {
    EtherAmount fundingBalance = await service.amountAirlineFunds(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    selectedActor.airlineFunding = fundingBalance;
  }

  @action
  Future<void> updateAirlineVotes() async {
    int votes = await service.numberAirlineVotes(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    selectedActor.airlineVotes = votes;
  }

  @action
  Future<void> updateAirlineStatus() async {
    bool registered = await service.isAirlineRegistered(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    selectedActor.isAirlineRegistered = registered;

    bool funded = await service.isAirlineFunded(
      airlineAddress: selectedActor.address,
      sender: selectedActor.address,
    );
    selectedActor.isAirlineRegistered = funded;
  }

  @action
  Future<void> updatePassengerBalance() async {
    EtherAmount payoutAmount = await service.passengerBalance(
      passenger: selectedActor.address,
      sender: selectedActor.address,
    );
    selectedActor.withdrawablePayout = payoutAmount;
  }

  @action
  Future<void> updateBalance(Actor actor) async {
    EtherAmount balance =
        await service.getAccountBalance(account: actor.address);
    selectedActor.accountBalance = balance;
    selectedAccountBalance = balance;
  }

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
