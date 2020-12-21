import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/prerequisites.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/utility/app_constants.dart';
import 'package:mobx/mobx.dart';

part 'account_store.g.dart';

final App appConstants = App.settings;

class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
  Prerequisites prerequisites;
  Map<String, Actor> actors;

  _AccountStore() {
    prerequisites = Prerequisites();
    actors = prerequisites.actors;
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
  bool isAccountConnected = false;

  @computed
  String get statusDescription =>
      isAccountConnected ? '${selectedActor.address.hex}' : 'Not Connected';

  @action
  void selectAccount(Actor actor) {
    selectedActor = actor;
    isAccountConnected = true;
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
}
