import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

enum ActorType { ContractOwner, Airline, Passenger, Oracle, Unassigned }

class Actor {
  EthereumAddress address;
  EthPrivateKey privateKey;
  ActorType actorType;

  Actor(@required this.address, @required this.privateKey, [this.actorType]);
}
