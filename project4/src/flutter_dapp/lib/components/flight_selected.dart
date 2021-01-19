import 'package:flutter/material.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FlightSelected extends StatefulWidget {
  @override
  _FlightSelectedState createState() => _FlightSelectedState();
}

class _FlightSelectedState extends State<FlightSelected> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (context) => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Selected Flight',
        ),
        readOnly: true,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: store.selectedFlight.flightIata ?? '',
          ),
        ),
      ),
    );
  }
}
