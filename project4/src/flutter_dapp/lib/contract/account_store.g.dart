// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountStore on _AccountStore, Store {
  Computed<bool> _$isAccountConnectedComputed;

  @override
  bool get isAccountConnected => (_$isAccountConnectedComputed ??=
          Computed<bool>(() => super.isAccountConnected,
              name: '_AccountStore.isAccountConnected'))
      .value;
  Computed<String> _$printedEtherAmountComputed;

  @override
  String get printedEtherAmount => (_$printedEtherAmountComputed ??=
          Computed<String>(() => super.printedEtherAmount,
              name: '_AccountStore.printedEtherAmount'))
      .value;
  Computed<String> _$selectedAccountDescriptionComputed;

  @override
  String get selectedAccountDescription =>
      (_$selectedAccountDescriptionComputed ??= Computed<String>(
              () => super.selectedAccountDescription,
              name: '_AccountStore.selectedAccountDescription'))
          .value;
  Computed<String> _$actorNameComputed;

  @override
  String get actorName =>
      (_$actorNameComputed ??= Computed<String>(() => super.actorName,
              name: '_AccountStore.actorName'))
          .value;

  final _$selectedActorAtom = Atom(name: '_AccountStore.selectedActor');

  @override
  Actor get selectedActor {
    _$selectedActorAtom.reportRead();
    return super.selectedActor;
  }

  @override
  set selectedActor(Actor value) {
    _$selectedActorAtom.reportWrite(value, super.selectedActor, () {
      super.selectedActor = value;
    });
  }

  final _$selectedPageIndexAtom = Atom(name: '_AccountStore.selectedPageIndex');

  @override
  int get selectedPageIndex {
    _$selectedPageIndexAtom.reportRead();
    return super.selectedPageIndex;
  }

  @override
  set selectedPageIndex(int value) {
    _$selectedPageIndexAtom.reportWrite(value, super.selectedPageIndex, () {
      super.selectedPageIndex = value;
    });
  }

  final _$accountChangedAtom = Atom(name: '_AccountStore.accountChanged');

  @override
  bool get accountChanged {
    _$accountChangedAtom.reportRead();
    return super.accountChanged;
  }

  @override
  set accountChanged(bool value) {
    _$accountChangedAtom.reportWrite(value, super.accountChanged, () {
      super.accountChanged = value;
    });
  }

  final _$carouselControllerAtom =
      Atom(name: '_AccountStore.carouselController');

  @override
  CarouselController get carouselController {
    _$carouselControllerAtom.reportRead();
    return super.carouselController;
  }

  @override
  set carouselController(CarouselController value) {
    _$carouselControllerAtom.reportWrite(value, super.carouselController, () {
      super.carouselController = value;
    });
  }

  final _$selectedAccountBalanceAtom =
      Atom(name: '_AccountStore.selectedAccountBalance');

  @override
  EtherAmount get selectedAccountBalance {
    _$selectedAccountBalanceAtom.reportRead();
    return super.selectedAccountBalance;
  }

  @override
  set selectedAccountBalance(EtherAmount value) {
    _$selectedAccountBalanceAtom
        .reportWrite(value, super.selectedAccountBalance, () {
      super.selectedAccountBalance = value;
    });
  }

  final _$updateAirlineFundingAsyncAction =
      AsyncAction('_AccountStore.updateAirlineFunding');

  @override
  Future<void> updateAirlineFunding() {
    return _$updateAirlineFundingAsyncAction
        .run(() => super.updateAirlineFunding());
  }

  final _$updateAirlineVotesAsyncAction =
      AsyncAction('_AccountStore.updateAirlineVotes');

  @override
  Future<void> updateAirlineVotes() {
    return _$updateAirlineVotesAsyncAction
        .run(() => super.updateAirlineVotes());
  }

  final _$updateAirlineStatusAsyncAction =
      AsyncAction('_AccountStore.updateAirlineStatus');

  @override
  Future<void> updateAirlineStatus() {
    return _$updateAirlineStatusAsyncAction
        .run(() => super.updateAirlineStatus());
  }

  final _$updatePassengerBalanceAsyncAction =
      AsyncAction('_AccountStore.updatePassengerBalance');

  @override
  Future<void> updatePassengerBalance() {
    return _$updatePassengerBalanceAsyncAction
        .run(() => super.updatePassengerBalance());
  }

  final _$updateBalanceAsyncAction = AsyncAction('_AccountStore.updateBalance');

  @override
  Future<void> updateBalance(Actor actor) {
    return _$updateBalanceAsyncAction.run(() => super.updateBalance(actor));
  }

  final _$_AccountStoreActionController =
      ActionController(name: '_AccountStore');

  @override
  void selectPage(int index) {
    final _$actionInfo = _$_AccountStoreActionController.startAction(
        name: '_AccountStore.selectPage');
    try {
      return super.selectPage(index);
    } finally {
      _$_AccountStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<DropdownMenuItem<Actor>> accountsDropdown() {
    final _$actionInfo = _$_AccountStoreActionController.startAction(
        name: '_AccountStore.accountsDropdown');
    try {
      return super.accountsDropdown();
    } finally {
      _$_AccountStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedActor: ${selectedActor},
selectedPageIndex: ${selectedPageIndex},
accountChanged: ${accountChanged},
carouselController: ${carouselController},
selectedAccountBalance: ${selectedAccountBalance},
isAccountConnected: ${isAccountConnected},
printedEtherAmount: ${printedEtherAmount},
selectedAccountDescription: ${selectedAccountDescription},
actorName: ${actorName}
    ''';
  }
}
