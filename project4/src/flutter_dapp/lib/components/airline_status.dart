import 'package:flutter/material.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AirlineStatus extends StatefulWidget {
  @override
  _AirlineStatusState createState() => _AirlineStatusState();
}

class _AirlineStatusState extends State<AirlineStatus> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (context) => ActionChip(
        label: Text(store.selectedActor.actorName),
        avatar: Icon(
          Icons.circle,
          color:
              store.selectedActor.isAirlineFunded ? Colors.green : Colors.red,
          size: 15,
        ),
        onPressed: () {},
      ),
    );
  }
}
