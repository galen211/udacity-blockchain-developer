import 'package:web3dart/web3dart.dart';

abstract class FlightSuretyEvent {
  List<dynamic> decodedData;

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    decodedData.forEach((substr) {
      buffer.writeln(substr);
    });
    return buffer.toString();
  }
}

class AirlineNominated implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;

  factory AirlineNominated(List<dynamic> decodedData) {
    AirlineNominated instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    return instance;
  }
}

class AirlineRegistered implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;

  factory AirlineRegistered(List<dynamic> decodedData) {
    AirlineRegistered instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    return instance;
  }
}

class AirlineFunded implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  EtherAmount amount;

  factory AirlineFunded(List<dynamic> decodedData) {
    AirlineFunded instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.amount = EtherAmount.inWei((decodedData[1] as BigInt));
    return instance;
  }
}

class FlightRegistered implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  String flight;

  factory FlightRegistered(List<dynamic> decodedData) {
    FlightRegistered instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.flight = decodedData[1] as String;
    return instance;
  }
}

class InsurancePurchased implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  EtherAmount amount;

  factory InsurancePurchased(List<dynamic> decodedData) {
    InsurancePurchased instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.amount = EtherAmount.inWei((decodedData[1] as BigInt));
    return instance;
  }
}

class InsurancePayout implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  String flight;

  factory InsurancePayout(List<dynamic> decodedData) {
    InsurancePayout instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.flight = decodedData[1] as String;
    return instance;
  }
}

class FlightStatusInfo implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  String flight;
  DateTime departureTime;
  int status;

  factory FlightStatusInfo(List<dynamic> decodedData) {
    FlightStatusInfo instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.flight = decodedData[1] as String;
    instance.departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[2] as BigInt).toInt());
    instance.status = decodedData[3] as int;
    return instance;
  }
}

class OracleReport implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  String flight;
  DateTime departureTime;
  int status;

  factory OracleReport(List<dynamic> decodedData) {
    OracleReport instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.flight = decodedData[1] as String;
    instance.departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[2] as BigInt).toInt());
    instance.status = decodedData[3] as int;
    return instance;
  }
}

class OracleRequest implements FlightSuretyEvent {
  @override
  List<dynamic> decodedData;

  EthereumAddress address;
  String flight;
  DateTime departureTime;
  int status;

  factory OracleRequest(List<dynamic> decodedData) {
    OracleRequest instance;
    instance.decodedData = decodedData;
    instance.address = decodedData[0] as EthereumAddress;
    instance.flight = decodedData[1] as String;
    instance.departureTime =
        DateTime.fromMillisecondsSinceEpoch((decodedData[2] as BigInt).toInt());
    instance.status = decodedData[3] as int;
    return instance;
  }
}
