import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

enum ActorType { ContractOwner, Airline, Passenger, Oracle, Unassigned }

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
      default:
        return 'Invalid';
    }
  }
}

extension WarningMessage on ActorType {
  String warningMessage() {
    return '${this.actorTypeName()} account is required.';
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
  bool isAirlineRegistered;
  bool isAirlineFunded;
  int airlineVotes;

  Actor({
    @required this.address,
    @required this.privateKey,
    @required this.actorType,
    this.actorName,
    this.accountBalance,
    this.withdrawablePayout,
    this.airlineFunding,
    this.isAirlineRegistered = false,
    this.isAirlineFunded = false,
    this.airlineVotes = 0,
  }) {
    actorName ??= 'Unassigned';
    accountBalance ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
    withdrawablePayout ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
    airlineFunding ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
  }
}
