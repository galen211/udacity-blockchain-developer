import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

mixin FlightSuretyEvent {
  void decode(ContractEvent event);
}

class AirlineNominated implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airlineAddress;

  AirlineNominated({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // final decoded = event.decodeResults(event.topics, event.data);
    // airlineAddress = decoded[0] as EthereumAddress;
  }
}

class AirlineRegistered implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airlineEthereumAddress;

  AirlineRegistered({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class AirlineFunded implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airlineEthereumAddress;
  BigInt amount;

  AirlineFunded({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class FlightRegistered implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airlineAddress;

  String flight;
  BigInt departureTime;
  FlightRegistered({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class InsurancePurchased implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress passengerAddress;
  BigInt amount;

  InsurancePurchased({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class InsurancePayout implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress passengerAddress;
  String flight;
  BigInt departureTime;

  InsurancePayout({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class FlightStatusInfo implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airline;
  String flight;
  BigInt departureTime;
  int status;

  FlightStatusInfo({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class OracleReport implements FlightSuretyEvent {
  ContractEvent event;
  EthereumAddress airline;
  String flight;
  BigInt departureTime;
  int status;

  OracleReport({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}

class OracleRequest implements FlightSuretyEvent {
  ContractEvent event;
  int index;
  EthereumAddress airline;
  String flight;
  BigInt departureTime;

  OracleRequest({@required this.event}) {
    this.decode(event);
  }

  @override
  void decode(ContractEvent event) {
    // TODO: implement decode
  }
}
