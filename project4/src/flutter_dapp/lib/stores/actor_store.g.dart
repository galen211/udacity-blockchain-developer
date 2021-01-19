// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ActorStore on _ActorStoreBase, Store {
  Computed<bool> _$isAirlineFundedComputed;

  @override
  bool get isAirlineFunded =>
      (_$isAirlineFundedComputed ??= Computed<bool>(() => super.isAirlineFunded,
              name: '_ActorStoreBase.isAirlineFunded'))
          .value;
  Computed<bool> _$isAirlineRegisteredComputed;

  @override
  bool get isAirlineRegistered => (_$isAirlineRegisteredComputed ??=
          Computed<bool>(() => super.isAirlineRegistered,
              name: '_ActorStoreBase.isAirlineRegistered'))
      .value;

  final _$addressAtom = Atom(name: '_ActorStoreBase.address');

  @override
  EthereumAddress get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(EthereumAddress value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$privateKeyAtom = Atom(name: '_ActorStoreBase.privateKey');

  @override
  EthPrivateKey get privateKey {
    _$privateKeyAtom.reportRead();
    return super.privateKey;
  }

  @override
  set privateKey(EthPrivateKey value) {
    _$privateKeyAtom.reportWrite(value, super.privateKey, () {
      super.privateKey = value;
    });
  }

  final _$actorTypeAtom = Atom(name: '_ActorStoreBase.actorType');

  @override
  ActorType get actorType {
    _$actorTypeAtom.reportRead();
    return super.actorType;
  }

  @override
  set actorType(ActorType value) {
    _$actorTypeAtom.reportWrite(value, super.actorType, () {
      super.actorType = value;
    });
  }

  final _$actorNameAtom = Atom(name: '_ActorStoreBase.actorName');

  @override
  String get actorName {
    _$actorNameAtom.reportRead();
    return super.actorName;
  }

  @override
  set actorName(String value) {
    _$actorNameAtom.reportWrite(value, super.actorName, () {
      super.actorName = value;
    });
  }

  final _$accountBalanceAtom = Atom(name: '_ActorStoreBase.accountBalance');

  @override
  EtherAmount get accountBalance {
    _$accountBalanceAtom.reportRead();
    return super.accountBalance;
  }

  @override
  set accountBalance(EtherAmount value) {
    _$accountBalanceAtom.reportWrite(value, super.accountBalance, () {
      super.accountBalance = value;
    });
  }

  final _$airlineFundingAtom = Atom(name: '_ActorStoreBase.airlineFunding');

  @override
  EtherAmount get airlineFunding {
    _$airlineFundingAtom.reportRead();
    return super.airlineFunding;
  }

  @override
  set airlineFunding(EtherAmount value) {
    _$airlineFundingAtom.reportWrite(value, super.airlineFunding, () {
      super.airlineFunding = value;
    });
  }

  final _$withdrawablePayoutAtom =
      Atom(name: '_ActorStoreBase.withdrawablePayout');

  @override
  EtherAmount get withdrawablePayout {
    _$withdrawablePayoutAtom.reportRead();
    return super.withdrawablePayout;
  }

  @override
  set withdrawablePayout(EtherAmount value) {
    _$withdrawablePayoutAtom.reportWrite(value, super.withdrawablePayout, () {
      super.withdrawablePayout = value;
    });
  }

  final _$airlineMembershipAtom =
      Atom(name: '_ActorStoreBase.airlineMembership');

  @override
  Membership get airlineMembership {
    _$airlineMembershipAtom.reportRead();
    return super.airlineMembership;
  }

  @override
  set airlineMembership(Membership value) {
    _$airlineMembershipAtom.reportWrite(value, super.airlineMembership, () {
      super.airlineMembership = value;
    });
  }

  final _$airlineVotesAtom = Atom(name: '_ActorStoreBase.airlineVotes');

  @override
  int get airlineVotes {
    _$airlineVotesAtom.reportRead();
    return super.airlineVotes;
  }

  @override
  set airlineVotes(int value) {
    _$airlineVotesAtom.reportWrite(value, super.airlineVotes, () {
      super.airlineVotes = value;
    });
  }

  @override
  String toString() {
    return '''
address: ${address},
privateKey: ${privateKey},
actorType: ${actorType},
actorName: ${actorName},
accountBalance: ${accountBalance},
airlineFunding: ${airlineFunding},
withdrawablePayout: ${withdrawablePayout},
airlineMembership: ${airlineMembership},
airlineVotes: ${airlineVotes},
isAirlineFunded: ${isAirlineFunded},
isAirlineRegistered: ${isAirlineRegistered}
    ''';
  }
}
