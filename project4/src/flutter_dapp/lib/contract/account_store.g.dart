// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountStore on _AccountStore, Store {
  Computed<Widget> _$selectedPageComputed;

  @override
  Widget get selectedPage =>
      (_$selectedPageComputed ??= Computed<Widget>(() => super.selectedPage,
              name: '_AccountStore.selectedPage'))
          .value;
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

  final _$airlineChangedAtom = Atom(name: '_AccountStore.airlineChanged');

  @override
  bool get airlineChanged {
    _$airlineChangedAtom.reportRead();
    return super.airlineChanged;
  }

  @override
  set airlineChanged(bool value) {
    _$airlineChangedAtom.reportWrite(value, super.airlineChanged, () {
      super.airlineChanged = value;
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

  final _$updateAirlineAsyncAction = AsyncAction('_AccountStore.updateAirline');

  @override
  Future<void> updateAirline(Actor actor) {
    return _$updateAirlineAsyncAction.run(() => super.updateAirline(actor));
  }

  final _$updateAirlineFundingAsyncAction =
      AsyncAction('_AccountStore.updateAirlineFunding');

  @override
  Future<void> updateAirlineFunding(Actor actor) {
    return _$updateAirlineFundingAsyncAction
        .run(() => super.updateAirlineFunding(actor));
  }

  final _$updateAirlineVotesAsyncAction =
      AsyncAction('_AccountStore.updateAirlineVotes');

  @override
  Future<void> updateAirlineVotes(Actor actor) {
    return _$updateAirlineVotesAsyncAction
        .run(() => super.updateAirlineVotes(actor));
  }

  final _$updateAirlineStatusAsyncAction =
      AsyncAction('_AccountStore.updateAirlineStatus');

  @override
  Future<void> updateAirlineStatus(Actor actor) {
    return _$updateAirlineStatusAsyncAction
        .run(() => super.updateAirlineStatus(actor));
  }

  final _$updatePassengerBalanceAsyncAction =
      AsyncAction('_AccountStore.updatePassengerBalance');

  @override
  Future<void> updatePassengerBalance(Actor actor) {
    return _$updatePassengerBalanceAsyncAction
        .run(() => super.updatePassengerBalance(actor));
  }

  final _$updateBalanceAsyncAction = AsyncAction('_AccountStore.updateBalance');

  @override
  Future<void> updateBalance(Actor actor) {
    return _$updateBalanceAsyncAction.run(() => super.updateBalance(actor));
  }

  final _$_AccountStoreActionController =
      ActionController(name: '_AccountStore');

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
airlineChanged: ${airlineChanged},
selectedAccountBalance: ${selectedAccountBalance},
selectedPage: ${selectedPage},
isAccountConnected: ${isAccountConnected},
printedEtherAmount: ${printedEtherAmount},
selectedAccountDescription: ${selectedAccountDescription},
actorName: ${actorName}
    ''';
  }
}
