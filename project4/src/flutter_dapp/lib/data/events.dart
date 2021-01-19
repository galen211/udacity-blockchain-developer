import 'package:web3dart/web3dart.dart';

enum EventType {
  AirlineNominated,
  AirlineRegistered,
  AirlineFunded,
  FlightRegistered,
  InsurancePurchased,
  InsurancePayout,
  InsuranceWithdrawal,
  FlightStatusInfo,
  OracleReport,
  OracleRequest,
  OracleRegistered,
}

extension EventTypeName on EventType {
  String eventName() {
    switch (this) {
      case EventType.AirlineNominated:
        return 'AirlineNominated';
        break;
      case EventType.AirlineRegistered:
        return 'AirlineRegistered';
        break;
      case EventType.AirlineFunded:
        return 'AirlineFunded';
        break;
      case EventType.FlightRegistered:
        return 'FlightRegistered';
        break;
      case EventType.InsurancePurchased:
        return 'InsurancePurchased';
        break;
      case EventType.InsurancePayout:
        return 'InsurancePayout';
        break;
      case EventType.InsuranceWithdrawal:
        return 'InsuranceWithdrawal';
        break;
      case EventType.FlightStatusInfo:
        return 'FlightStatusInfo';
        break;
      case EventType.OracleRequest:
        return 'OracleRequest';
        break;
      case EventType.OracleReport:
        return 'OracleReport';
        break;
      case EventType.OracleRegistered:
        return 'OracleRegistered';
        break;
      default:
        throw 'EventType ${this.toString()} not recognized';
    }
  }
}

extension on FlightSuretyEvent {
  String etherAmountPrinted(EtherAmount amount) {
    return '${(amount.getValueInUnit(EtherUnit.finney) / 1000).toStringAsFixed(4)} ETH';
  }
}

extension on FlightSuretyEvent {
  String statusDescription(int status) {
    switch (status) {
      case 0:
        return 'Unknown';
        break;
      case 10:
        return 'On Time';
        break;
      case 20:
        return 'Late Due to Airline';
        break;
      case 30:
        return 'Late Due to Weather';
        break;
      case 40:
        return 'Late Due to Technical Problems';
        break;
      case 50:
        return 'Late Due to Other Causes';
        break;
      default:
        throw 'Unrecognized Flight Status Code: $status';
    }
  }
}

abstract class FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  String description();

  factory FlightSuretyEvent(EventType eventType, List<dynamic> decodedData) {
    switch (eventType) {
      case EventType.AirlineNominated:
        return AirlineNominated(eventType, decodedData);
      case EventType.AirlineRegistered:
        return AirlineRegistered(eventType, decodedData);
      case EventType.AirlineFunded:
        return AirlineFunded(eventType, decodedData);
      case EventType.FlightRegistered:
        return FlightRegistered(eventType, decodedData);
      case EventType.InsurancePurchased:
        return InsurancePurchased(eventType, decodedData);
      case EventType.InsurancePayout:
        return InsurancePayout(eventType, decodedData);
      case EventType.InsuranceWithdrawal:
        return InsuranceWithdrawal(eventType, decodedData);
      case EventType.FlightStatusInfo:
        return FlightStatusInfo(eventType, decodedData);
      case EventType.OracleReport:
        return OracleReport(eventType, decodedData);
      case EventType.OracleRequest:
        return OracleRequest(eventType, decodedData);
      case EventType.OracleRegistered:
        return OracleRegistered(eventType, decodedData);
      default:
        throw 'Cannot create event from given EventType ${eventType.eventName()}';
    }
  }
}

class AirlineNominated implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;

  AirlineNominated(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    return buffer.toString();
  }
}

class AirlineRegistered implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;

  AirlineRegistered(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    return buffer.toString();
  }
}

class AirlineFunded implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  EtherAmount amount;

  AirlineFunded(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    amount = EtherAmount.inWei((decodedData[1] as BigInt));
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Amount: ${this.etherAmountPrinted(amount)}');
    return buffer.toString();
  }
}

class FlightRegistered implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  String flight;

  FlightRegistered(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    flight = decodedData[1] as String;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Flight: $flight');
    return buffer.toString();
  }
}

class InsurancePurchased implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  EtherAmount amount;

  InsurancePurchased(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    amount = EtherAmount.inWei((decodedData[1] as BigInt));
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Amount: ${this.etherAmountPrinted(amount)}');
    return buffer.toString();
  }
}

class InsurancePayout implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  String flight;

  InsurancePayout(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    flight = decodedData[1] as String;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Flight: $flight');
    return buffer.toString();
  }
}

class InsuranceWithdrawal implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  EtherAmount amount;

  InsuranceWithdrawal(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    amount = decodedData[1] as EtherAmount;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Amount: ${this.etherAmountPrinted(amount)}');
    return buffer.toString();
  }
}

class FlightStatusInfo implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  String flight;
  DateTime departureTime;
  int status;

  FlightStatusInfo(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    flight = decodedData[1] as String;
    departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[2] as BigInt).toInt());
    status = decodedData[3] as int;
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Flight: $flight');
    buffer.writeln(
        'Departure Time: ${departureTime.millisecondsSinceEpoch} ${departureTime.toIso8601String()}');
    buffer.write('Status: $status, ${this.statusDescription(status)}');
    return buffer.toString();
  }
}

class OracleReport implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  String flight;
  DateTime departureTime;
  int status;

  OracleReport(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    flight = decodedData[1] as String;
    departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[2] as BigInt).toInt());
    status = (decodedData[3] as BigInt).toInt();
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Flight: $flight');
    buffer.write('Departure Time: ${departureTime.toIso8601String()}');
    buffer.write('Status: ${this.statusDescription(status)}');
    return buffer.toString();
  }
}

class OracleRequest implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  int index;
  EthereumAddress address;
  String flight;
  DateTime departureTime;

  OracleRequest(this.eventType, this.decodedData) {
    index = (decodedData[0] as BigInt).toInt();
    address = decodedData[1] as EthereumAddress;
    flight = decodedData[2] as String;
    departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[3] as BigInt).toInt());
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('Flight: $flight');
    buffer.write('Departure Time: ${departureTime.toIso8601String()}');
    return buffer.toString();
  }
}

class OracleRegistered implements FlightSuretyEvent {
  final List decodedData;
  final EventType eventType;

  EthereumAddress address;
  List<int> indexes;

  OracleRegistered(this.eventType, this.decodedData) {
    address = decodedData[0] as EthereumAddress;
    indexes = (decodedData[1] as List<dynamic>)
        .map((e) => e.toInt())
        .toList()
        .cast<int>();
  }

  @override
  String description() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Address: ${address.hex}');
    buffer.write('\t Indexes:');
    indexes.forEach((idx) {
      buffer.write(' $idx');
    });
    return buffer.toString();
  }
}
