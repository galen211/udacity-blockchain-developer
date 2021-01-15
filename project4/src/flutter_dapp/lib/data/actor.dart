import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

enum ActorType {
  ContractOwner,
  Airline,
  Passenger,
  Oracle,
  Unassigned,
  NotConnected
}

extension ParseToString on ActorType {
  String actorTypeName() {
    switch (this) {
      case ActorType.ContractOwner:
        return 'Contract Owner';
        break;
      case ActorType.Airline:
        return 'Airline';
        break;
      case ActorType.Passenger:
        return 'Passenger';
        break;
      case ActorType.Oracle:
        return 'Oracle';
        break;
      case ActorType.Unassigned:
        return 'Unassigned';
        break;
      case ActorType.NotConnected:
        return 'Not Connected';
        break;
      default:
        return 'Invalid';
        break;
    }
  }
}

extension WarningMessage on ActorType {
  String warningMessage() {
    return '${this.actorTypeName()} account is required.';
  }
}

enum Membership {
  Unknown,
  Nominated,
  Registered,
  Funded,
}

extension MembershipDescription on Membership {
  String membershipDescription() {
    switch (this) {
      case Membership.Unknown:
        return 'Unknown';
        break;
      case Membership.Nominated:
        return 'Nominated';
        break;
      case Membership.Registered:
        return 'Registered';
        break;
      case Membership.Funded:
        return 'Funded';
        break;
      default:
        throw 'Invalid membership type';
    }
  }
}

class Actor {
  EthereumAddress address;
  EthPrivateKey privateKey;
  ActorType actorType;
  String actorName;
  EtherAmount accountBalance;
  EtherAmount airlineFunding;
  EtherAmount withdrawablePayout;
  Membership airlineMembership;
  int airlineVotes;

  Actor({
    @required this.address,
    @required this.privateKey,
    @required this.actorType,
    this.actorName,
    this.accountBalance,
    this.withdrawablePayout,
    this.airlineFunding,
    this.airlineMembership = Membership.Unknown,
    this.airlineVotes = 0,
  }) {
    actorName ??= 'Unassigned';
    accountBalance ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
    withdrawablePayout ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
    airlineFunding ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
  }

  bool isAirlineFunded() {
    return this.airlineMembership == Membership.Funded;
  }

  bool isAirlineRegistered() {
    return this.airlineMembership == Membership.Registered;
  }

  void updateActorName(String name) {
    this.actorName = name;
  }

  static Actor nullActor() {
    Actor actor = Actor(
      actorType: ActorType.NotConnected,
      address:
          EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      privateKey:
          EthPrivateKey.fromHex('0x0000000000000000000000000000000000000000'),
      actorName: 'Not Connected',
      accountBalance: EtherAmount.zero(),
      withdrawablePayout: EtherAmount.zero(),
      airlineFunding: EtherAmount.zero(),
      airlineMembership: Membership.Unknown,
      airlineVotes: 0,
    );
    return actor;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Actor &&
        o.address == address &&
        o.privateKey == privateKey &&
        o.actorName == actorName &&
        o.accountBalance == accountBalance &&
        o.airlineFunding == airlineFunding &&
        o.withdrawablePayout == withdrawablePayout &&
        o.airlineMembership == airlineMembership &&
        o.airlineVotes == airlineVotes;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        privateKey.hashCode ^
        actorName.hashCode ^
        accountBalance.hashCode ^
        airlineFunding.hashCode ^
        withdrawablePayout.hashCode ^
        airlineMembership.hashCode ^
        airlineVotes.hashCode;
  }
}
