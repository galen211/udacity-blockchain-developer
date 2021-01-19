import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PassengerStatus extends StatefulWidget {
  @override
  _PassengerStatusState createState() => _PassengerStatusState();
}

class _PassengerStatusState extends State<PassengerStatus> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (context) => ActionChip(
        label: Text(store.selectedActor.actorName),
        avatar: Icon(
          Icons.circle,
          color: store.selectedActor.actorType == ActorType.Passenger
              ? Colors.green
              : Colors.red,
          size: 15,
        ),
        onPressed: () {},
      ),
    );
  }
}
