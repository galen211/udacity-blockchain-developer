// import 'package:flutter_dapp/contract/prerequisites.dart';
// import 'package:flutter_dapp/data/actor_enums.dart';
// import 'package:mobx/mobx.dart';
// import 'package:web3dart/web3dart.dart';

// part 'actor_store.g.dart';

// class MultiActorStore = _MultiActorStoreBase with _$MultiActorStore;

// abstract class _MultiActorStoreBase with Store {
//   @observable
//   ObservableMap<String, ActorStore> actors;

//   _MultiActorStoreBase() {
//     Prerequisites prerequisites = Prerequisites();
//     setupValidations();
//   }

//   @observable
//   ActorStore selectedAccount;

//   @observable
//   ActorStore selectedAirline;

//   void dispose() {
//     _disposers.forEach((disposer) {
//       disposer();
//     });
//   }

//   void setupValidations() {
//     _disposers = [
//       autorun((_) {
//         if (!(selectedActor.actorType == ActorType.NotConnected)) {
//           updateBalance(selectedActor);
//         }
//       }),
//       autorun((_) {
//         if (selectedActor.actorType == ActorType.Airline) {
//           updateAirline(selectedActor);
//         }
//       }),
//       autorun((_) {
//         if (selectedActor.actorType == ActorType.Passenger) {
//           updatePassengerBalance(selectedActor);
//         }
//       }),
//     ];
//   }
// }

// class ActorStore = _ActorStoreBase with _$ActorStore;

// abstract class _ActorStoreBase with Store {
//   @observable
//   EthereumAddress address;

//   @observable
//   EthPrivateKey privateKey;

//   @observable
//   ActorType actorType;

//   @observable
//   String actorName;

//   @observable
//   EtherAmount accountBalance;

//   @observable
//   EtherAmount airlineFunding;

//   @observable
//   EtherAmount withdrawablePayout;

//   @observable
//   Membership airlineMembership;

//   @observable
//   int airlineVotes;

//   _ActorStoreBase({
//     this.address,
//     this.privateKey,
//     this.actorType,
//     this.actorName,
//     this.accountBalance,
//     this.withdrawablePayout,
//     this.airlineFunding,
//     this.airlineMembership = Membership.Unknown,
//     this.airlineVotes = 0,
//   }) {
//     actorName ??= 'Unassigned';
//     accountBalance ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
//     withdrawablePayout ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
//     airlineFunding ??= EtherAmount.fromUnitAndValue(EtherUnit.ether, 0);
//   }

//   @action
//   bool isAirlineFunded() {
//     return this.airlineMembership == Membership.Funded;
//   }

//   @action
//   bool isAirlineRegistered() {
//     return this.airlineMembership == Membership.Registered;
//   }
// }
