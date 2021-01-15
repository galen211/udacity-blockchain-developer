// import 'package:flutter/material.dart';
// import 'package:web3dart/web3dart.dart';

// enum ActorType {
//   ContractOwner,
//   Airline,
//   Passenger,
//   Oracle,
//   Unassigned,
//   NotConnected
// }

// extension ParseToString on ActorType {
//   String actorTypeName() {
//     switch (this) {
//       case ActorType.ContractOwner:
//         return 'Contract Owner';
//         break;
//       case ActorType.Airline:
//         return 'Airline';
//         break;
//       case ActorType.Passenger:
//         return 'Passenger';
//         break;
//       case ActorType.Oracle:
//         return 'Oracle';
//         break;
//       case ActorType.Unassigned:
//         return 'Unassigned';
//         break;
//       case ActorType.NotConnected:
//         return 'Not Connected';
//         break;
//       default:
//         return 'Invalid';
//         break;
//     }
//   }
// }

// extension WarningMessage on ActorType {
//   String warningMessage() {
//     return '${this.actorTypeName()} account is required.';
//   }
// }

// enum Membership {
//   Unknown,
//   Nominated,
//   Registered,
//   Funded,
// }

// extension MembershipDescription on Membership {
//   String membershipDescription() {
//     switch (this) {
//       case Membership.Unknown:
//         return 'Unknown';
//         break;
//       case Membership.Nominated:
//         return 'Nominated';
//         break;
//       case Membership.Registered:
//         return 'Registered';
//         break;
//       case Membership.Funded:
//         return 'Funded';
//         break;
//       default:
//         throw 'Invalid membership type';
//     }
//   }
// }
