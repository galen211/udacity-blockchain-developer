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
  Computed<ActorType> _$currentActorTypeComputed;

  @override
  ActorType get currentActorType => (_$currentActorTypeComputed ??=
          Computed<ActorType>(() => super.currentActorType,
              name: '_AccountStore.currentActorType'))
      .value;

  final _$accountsAtom = Atom(name: '_AccountStore.accounts');

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

  final _$selectedAccountAtom = Atom(name: '_AccountStore.selectedAccount');

  @override
  ActorStore get selectedAccount {
    _$selectedAccountAtom.reportRead();
    return super.selectedAccount;
  }

  @override
  set selectedAccount(ActorStore value) {
    _$selectedAccountAtom.reportWrite(value, super.selectedAccount, () {
      super.selectedAccount = value;
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

  final _$updateAirlineFundingAsyncAction =
      AsyncAction('_AccountStore.updateAirlineFunding');

  @override
  Future<void> updateAirlineFunding(ActorStore actor) {
    return _$updateAirlineFundingAsyncAction
        .run(() => super.updateAirlineFunding(actor));
  }

  final _$updateAirlineVotesAsyncAction =
      AsyncAction('_AccountStore.updateAirlineVotes');

  @override
  Future<void> updateAirlineVotes(ActorStore actor) {
    return _$updateAirlineVotesAsyncAction
        .run(() => super.updateAirlineVotes(actor));
  }

  final _$updatePassengerBalanceAsyncAction =
      AsyncAction('_AccountStore.updatePassengerBalance');

  @override
  Future<void> updatePassengerBalance(ActorStore actor) {
    return _$updatePassengerBalanceAsyncAction
        .run(() => super.updatePassengerBalance(actor));
  }

  final _$updateBalanceAsyncAction = AsyncAction('_AccountStore.updateBalance');

  @override
  Future<void> updateBalance(ActorStore actor) {
    return _$updateBalanceAsyncAction.run(() => super.updateBalance(actor));
  }

  final _$_AccountStoreActionController =
      ActionController(name: '_AccountStore');

  @override
  List<DropdownMenuItem<ActorStore>> accountsDropdown() {
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
accounts: ${accounts},
selectedAccount: ${selectedAccount},
selectedPageIndex: ${selectedPageIndex},
accountChanged: ${accountChanged},
airlineChanged: ${airlineChanged},
selectedPage: ${selectedPage},
isAccountConnected: ${isAccountConnected},
printedEtherAmount: ${printedEtherAmount},
selectedAccountDescription: ${selectedAccountDescription},
actorName: ${actorName},
currentActorType: ${currentActorType}
    ''';
  }
}
