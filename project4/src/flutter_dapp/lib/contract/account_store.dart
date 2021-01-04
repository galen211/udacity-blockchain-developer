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
  int selectedPageIndex = 0;

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
  Actor selectedActor;

  @observable
  EtherAmount selectedAccountBalance =
      EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);

  @computed
  bool get isAccountConnected => selectedActor != null;

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
    ];
  }

  @computed
  String get selectedAccountDescription => selectedActor == null
      ? 'Not Connected'
      : '${selectedActor.actorType.actorTypeName()}: ${selectedActor.address.hex.substring(0, 6)}...${selectedActor.address.hex.substring(35, 41)} | Balance: $printedEtherAmount ETH';

  @action
  Future<void> updateBalance(Actor actor) async {
    if (actor == null) return;
    EtherAmount balance = await service.queryAvailableBalance(actor.address);
    selectedActor.accountBalance = balance;
    selectedAccountBalance = balance;
  }

  @action
  String actorName() {
    return actors.keys
        .firstWhere((key) => actors[key].address == selectedActor.address);
  }

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

  @action
  Future<void> showAccountSelection(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Account'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<Actor>(
                  hint: Text("Choose an account to use"),
                  isDense: true,
                  isExpanded: true,
                  value: selectedActor,
                  items: accountsDropdown(),
                  onChanged: (value) {
                    selectedActor = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                final snackBar = SnackBar(
                  content: Text(
                      'You are now transacting as "${selectedActor.actorName}" at address: ${selectedActor.address.hex}'),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
