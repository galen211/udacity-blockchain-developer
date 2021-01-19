import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/pages/airlines.dart';
import 'package:flutter_dapp/pages/oracles.dart';
import 'package:flutter_dapp/pages/passengers.dart';
import 'package:flutter_dapp/pages/scenario.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/contract_service.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'account_store.g.dart';

final App appConstants = App.settings;

class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
  Prerequisites prerequisites;

  ContractService service;

  @observable
  ObservableMap<EthereumAddress, ActorStore> accounts;

  @observable
  ActorStore selectedAccount = ActorStore();

  _AccountStore(ContractService contractService, FlightDataStore data) {
    prerequisites = Prerequisites();
    accounts = data.accounts;
    service = contractService;
    setupValidations();
  }

  List<ReactionDisposer> _disposers;

  void dispose() {
    _disposers.forEach((disposer) {
      disposer();
    });
  }

  void setupValidations() {
    _disposers = [
      autorun((_) {
        if (currentActorType != ActorType.NotConnected) {
          updateBalance(selectedAccount);
        }
      }),
      // autorun((_) {
      //   if (selectedActor.actorType == ActorType.Airline) {
      //     updateAirline(selectedActor);
      //   }
      // }),
      // autorun((_) {
      //   if (selectedActor.actorType == ActorType.Passenger) {
      //     updatePassengerBalance(selectedActor);
      //   }
      // }),
    ];
  }

  Future<void> updateAirline(ActorStore actor) async {
    await Future.wait([
      updateAirlineFunding(actor),
      updateAirlineStatus(actor),
      updateAirlineVotes(actor),
    ]);
  }

  @action
  Future<void> updateAirlineFunding(ActorStore actor) async {
    EtherAmount fundingBalance = await service.amountAirlineFunds(
      airlineAddress: actor.address,
      sender: selectedAccount.address,
    );
    accounts[actor.address].airlineFunding = fundingBalance;
  }

  @action
  Future<void> updateAirlineVotes(ActorStore actor) async {
    int votes = await service.numberAirlineVotes(
      airlineAddress: actor.address,
      sender: selectedAccount.address,
    );
    accounts[actor.address].airlineVotes = votes;
  }

  Future<void> updateAirlineStatus(ActorStore actor) async {
    int membership = await service.airlineMembership(
      airlineAddress: actor.address,
      sender: selectedAccount.address,
    );

    switch (membership) {
      case 0:
        actor.airlineMembership = Membership.Nonmember;
        break;
      case 1:
        actor.airlineMembership = Membership.Nominated;
        break;
      case 2:
        actor.airlineMembership = Membership.Registered;
        break;
      case 3:
        actor.airlineMembership = Membership.Funded;
        break;
      default:
        throw 'Unrecognized airline membership category';
    }
  }

  @action
  Future<void> updatePassengerBalance(ActorStore actor) async {
    EtherAmount payoutAmount = await service.passengerBalance(
      passenger: selectedAccount.address,
      sender: selectedAccount.address,
    );
    accounts[actor.address].withdrawablePayout = payoutAmount;
  }

  @action
  Future<void> updateBalance(ActorStore actor) async {
    EtherAmount balance =
        await service.getAccountBalance(account: actor.address);
    accounts[actor.address].accountBalance = balance;
  }

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

  @computed
  bool get isAccountConnected =>
      selectedAccount.actorType != ActorType.NotConnected;

  @computed
  String get printedEtherAmount =>
      (selectedAccount.accountBalance.getValueInUnit(EtherUnit.finney) / 1000)
          .toStringAsFixed(4);

  @computed
  String get selectedAccountDescription => selectedAccount.actorName ==
          'Not Connected'
      ? 'Not Connected'
      : '${selectedAccount.actorType.actorTypeName()}: ${selectedAccount.address.hex.substring(0, 6)}...${selectedAccount.address.hex.substring(35, 41)} | Balance: $printedEtherAmount ETH';

  @computed
  String get actorName => selectedAccount.actorName;

  @computed
  ActorType get currentActorType => selectedAccount.actorType;

  @action
  List<DropdownMenuItem<ActorStore>> accountsDropdown() {
    List<DropdownMenuItem<ActorStore>> dropdown = [];
    accounts.values.forEach((value) {
      dropdown.add(DropdownMenuItem<ActorStore>(
        child: Text(value.actorName),
        value: value,
      ));
    });
    return dropdown;
  }
}
