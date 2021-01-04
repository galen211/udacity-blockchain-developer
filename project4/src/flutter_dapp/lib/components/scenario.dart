import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dapp/components/event_log.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (context) => Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'Scenario Setup',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 475,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'App Contract Address',
                          suffixIcon: Icon(
                            Icons.circle,
                            color: store.isAppOperational
                                ? Colors.green
                                : Colors.red,
                            size: 10,
                          ),
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(text: store.appContractAddress.hex),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 475,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Data Contract Address',
                          suffixIcon: Icon(
                            Icons.circle,
                            color: store.isAppOperational
                                ? Colors.green
                                : Colors.red,
                            size: 10,
                          ),
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(text: store.dataContractAddress.hex),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'App Controls',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                overflowDirection: VerticalDirection.down,
                buttonPadding: EdgeInsets.all(20),
                children: [
                  PermissionedButton(
                    requiredRole: ActorType.ContractOwner,
                    action: () async {
                      store.isTransactionPending = true;
                      await store.setOperatingStatus();
                      store.isTransactionPending = false;
                    },
                    buttonText: store.isAppOperational
                        ? 'Disable Operation'
                        : 'Enable Operation',
                    disableCondition: store.isTransactionPending,
                  ),
                  PermissionedButton(
                      requiredRole: ActorType.ContractOwner,
                      action: () async {
                        store.isTransactionPending = true;
                        await store.registerAllAirlines();
                        store.isTransactionPending = false;
                      },
                      buttonText: 'Setup Airline Consortium',
                      disableCondition: store.isAirlinesSetup ||
                          store.isTransactionPending ||
                          !store.isAppOperational),
                  PermissionedButton(
                      requiredRole: ActorType.ContractOwner,
                      action: () async {
                        store.isTransactionPending = true;
                        await store.registerAllFlights();
                        store.isTransactionPending = false;
                      },
                      buttonText: 'Register Flights',
                      disableCondition: store.isFlightsRegistered ||
                          store.isTransactionPending ||
                          !store.isAppOperational),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: EventLog(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
