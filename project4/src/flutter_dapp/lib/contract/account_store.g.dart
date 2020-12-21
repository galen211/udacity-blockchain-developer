// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountStore on _AccountStore, Store {
  Computed<String> _$statusDescriptionComputed;

  @override
  String get statusDescription => (_$statusDescriptionComputed ??=
          Computed<String>(() => super.statusDescription,
              name: '_AccountStore.statusDescription'))
      .value;

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

  final _$isAccountConnectedAtom =
      Atom(name: '_AccountStore.isAccountConnected');

  @override
  bool get isAccountConnected {
    _$isAccountConnectedAtom.reportRead();
    return super.isAccountConnected;
  }

  @override
  set isAccountConnected(bool value) {
    _$isAccountConnectedAtom.reportWrite(value, super.isAccountConnected, () {
      super.isAccountConnected = value;
    });
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
  void selectAccount(Actor actor) {
    final _$actionInfo = _$_AccountStoreActionController.startAction(
        name: '_AccountStore.selectAccount');
    try {
      return super.selectAccount(actor);
    } finally {
      _$_AccountStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String actorName() {
    final _$actionInfo = _$_AccountStoreActionController.startAction(
        name: '_AccountStore.actorName');
    try {
      return super.actorName();
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
selectedPageIndex: ${selectedPageIndex},
carouselController: ${carouselController},
selectedActor: ${selectedActor},
isAccountConnected: ${isAccountConnected},
statusDescription: ${statusDescription}
    ''';
  }
}
