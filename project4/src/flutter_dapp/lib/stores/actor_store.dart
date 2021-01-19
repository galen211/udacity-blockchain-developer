import 'package:flutter_dapp/data/enums.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

part 'actor_store.g.dart';

class ActorStore = _ActorStoreBase with _$ActorStore;

abstract class _ActorStoreBase with Store {
  @observable
  EthereumAddress address;

  @observable
  EthPrivateKey privateKey;

  @observable
  ActorType actorType;

  @observable
  String actorName;

  @observable
  EtherAmount accountBalance;

  @observable
  EtherAmount airlineFunding;

  @observable
  EtherAmount withdrawablePayout;

  @observable
  Membership airlineMembership;

  @observable
  int airlineVotes;

  _ActorStoreBase({
    this.address,
    this.privateKey,
    this.actorType,
    this.actorName,
    this.accountBalance,
    this.withdrawablePayout,
    this.airlineFunding,
    this.airlineMembership,
    this.airlineVotes,
  }) {
    address ??=
        EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
    privateKey ??=
        EthPrivateKey.fromHex('0x0000000000000000000000000000000000000000');
    actorType ??= ActorType.NotConnected;
    actorName ??= 'Not Connected';
    accountBalance ??= EtherAmount.zero();
    withdrawablePayout ??= EtherAmount.zero();
    airlineFunding ??= EtherAmount.zero();
    airlineMembership ??= Membership.Nonmember;
    airlineVotes ??= 0;
    actorName ??= 'Unassigned';
  }

  @computed
  bool get isAirlineFunded => airlineMembership == Membership.Funded;

  @computed
  bool get isAirlineRegistered => airlineMembership == Membership.Registered;
}
