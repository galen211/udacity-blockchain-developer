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
  Nonmember,
  Nominated,
  Registered,
  Funded,
}

extension MembershipDescription on Membership {
  String membershipDescription() {
    switch (this) {
      case Membership.Nonmember:
        return 'Nonmember';
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

enum FlightStatus {
  Unknown,
  LateAirline,
  LateWeather,
  LateTechnical,
  LateOther,
  OnTime,
}

extension StatusDescription on FlightStatus {
  String description() {
    switch (this) {
      case FlightStatus.Unknown:
        return 'Unknown';
        break;
      case FlightStatus.LateAirline:
        return 'Late Airline';
        break;
      case FlightStatus.LateWeather:
        return 'Late Weather';
        break;
      case FlightStatus.LateTechnical:
        return 'Late Technical';
        break;
      case FlightStatus.LateOther:
        return 'Late Other';
        break;
      case FlightStatus.OnTime:
        return 'On Time';
        break;
      default:
        return 'Invalid Flight Status';
        break;
    }
  }
}
