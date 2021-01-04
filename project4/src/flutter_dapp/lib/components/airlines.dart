import 'package:flutter/material.dart';

import 'package:flutter_dapp/components/date_input.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/contract/account_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'account_warning.dart';

class AirlinePage extends StatefulWidget {
  @override
  _AirlinePageState createState() => _AirlinePageState();
}

class _AirlinePageState extends State<AirlinePage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountStore>(context);
    return Observer(
      builder: (context) => Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'Airline Management',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Airline Details",
                style: Theme.of(context).textTheme.headline6,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Selected Account Address',
                          ),
                          readOnly: true,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: store.selectedActor == null
                                  ? ''
                                  : store.selectedActor.address.hex,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Selected Account Name',
                          ),
                          readOnly: store?.selectedActor?.actorType ==
                                  ActorType.Unassigned
                              ? false
                              : true,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: store.selectedActor == null
                                  ? ''
                                  : store.selectedActor.actorName,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Funding Amount',
                            suffix: Text('ETH'),
                          ),
                          readOnly: store?.selectedActor?.actorType ==
                                  ActorType.Unassigned
                              ? false
                              : true,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: store.selectedActor == null
                                  ? ''
                                  : store
                                      .selectedActor.airlineFunding.getInEther
                                      .toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AccountWarning(ActorType.Airline),
              SizedBox(
                height: 20,
              ),
              Text(
                "Register Flight",
                style: Theme.of(context).textTheme.headline6,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Flight Code',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Departure Airport',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Arrival Airport',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DateTimeInput(),
              ),
              Expanded(
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  overflowDirection: VerticalDirection.down,
                  buttonPadding: EdgeInsets.all(20),
                  children: [
                    PermissionedButton(
                        requiredRole: ActorType.Unassigned,
                        action: () async =>
                            await Future.delayed(Duration(seconds: 3))
                                .then((_) => print('registerAirline')),
                        buttonText: 'Register Airline',
                        disableCondition:
                            store.selectedActor?.isAirlineRegistered ?? false),
                    PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () async =>
                            await Future.delayed(Duration(seconds: 3))
                                .then((_) => print('fundAirline')),
                        buttonText: 'Fund Airline',
                        disableCondition:
                            store.selectedActor?.isAirlineFunded ?? false),
                    PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () async {
                          //store.isTransactionPending = true;
                          //
                          //store.isTransactionPending = false;
                        },
                        buttonText: 'Register Flight',
                        disableCondition:
                            store.selectedActor?.isAirlineFunded ?? false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
