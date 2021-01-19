import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dapp/components/flight_selected.dart';
import 'package:flutter_dapp/components/flight_table.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PassengerPage extends StatefulWidget {
  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              'Purchase Flight Insurance',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Observer(
              builder: (context) => store.flights.values
                          .where((flight) => flight.registered == true)
                          .length <
                      1
                  ? Container(
                      child: Center(
                        child: Text("No flights are currently registered"),
                      ),
                    )
                  : FlightTable(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                flex: 2,
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  overflowDirection: VerticalDirection.down,
                  buttonPadding: EdgeInsets.all(8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PermissionedButton(
                        requiredRole: ActorType.Passenger,
                        action: () {
                          store.purchaseInsurance();
                        },
                        buttonText: 'Buy Insurance',
                        disableCondition: store.isTransactionPending,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Rename Passenger',
                      ),
                      readOnly: !(store.selectedActor.actorType ==
                          ActorType.Unassigned),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: store.selectedActor.actorName,
                            selection: TextSelection.collapsed(
                                offset: store.selectedActor.actorName.length)),
                      ),
                      onChanged: (value) {
                        store.selectedActor.actorName = value;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Insurance Amount',
                        suffix: Text('ETH'),
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: store.etherAmountText(store.insuranceAmount)),
                      ),
                    );
                  }),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlightSelected(),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
