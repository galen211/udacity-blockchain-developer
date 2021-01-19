import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/airline_details.dart';
import 'package:flutter_dapp/components/airline_status.dart';
import 'package:flutter_dapp/components/flight_registration.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_dapp/stores/flight_registration_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AirlinePage extends StatefulWidget {
  @override
  _AirlinePageState createState() => _AirlinePageState();
}

class _AirlinePageState extends State<AirlinePage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Padding(
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
          Text(
            "Proposed Airline Member",
            style: Theme.of(context).textTheme.headline6,
          ),
          AirlineDetails(),
          Divider(
            height: 6,
          ),
          Row(
            children: [
              Text(
                "Connected Account",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                width: 20,
              ),
              AirlineStatus(),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Airline Address',
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.selectedActor.address.hex,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Airline Status',
                        suffixIcon: Icon(
                          Icons.circle,
                          color: store.selectedActor.isAirlineFunded
                              ? Colors.green
                              : Colors.red,
                          size: 10,
                        ),
                      ),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.selectedActor.airlineMembership
                              .membershipDescription(),
                        ),
                      ),
                      readOnly: true,
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number of Votes',
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: '${store.selectedActor.airlineVotes}',
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Funding Amount',
                        suffix: Text('ETH'),
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.etherAmountText(
                              store.selectedActor.airlineFunding),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Text(
            "Register Flight",
            style: Theme.of(context).textTheme.headline6,
          ),
          FlightRegistrationForm(),
          Row(
            children: [
              Observer(builder: (_) {
                return ButtonBar(
                    alignment: MainAxisAlignment.start,
                    overflowDirection: VerticalDirection.down,
                    buttonPadding: EdgeInsets.all(20),
                    children: [
                      PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () {
                          store.nominateAirline();
                        },
                        buttonText: 'Nominate Airline',
                        unassignedRoleAllowed: true,
                        disableCondition: !store.selectedActor.isAirlineFunded,
                      ),
                      PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () {
                          store.registerAirline();
                        },
                        buttonText: 'Register Airline',
                        disableCondition: !store.selectedActor.isAirlineFunded,
                      ),
                      PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () {
                          store.fundAirline();
                        },
                        buttonText: 'Fund Airline',
                        disableCondition:
                            !(store.selectedActor.isAirlineRegistered ||
                                store.selectedActor.isAirlineFunded),
                      ),
                      PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () {
                          store.registerFlight();
                        },
                        buttonText: 'Register Flight',
                        disableCondition: !store.selectedActor.isAirlineFunded,
                      ),
                      Builder(builder: (context) {
                        final form =
                            Provider.of<FlightRegistrationStore>(context);
                        return ElevatedButton(
                          onPressed: () {
                            form.clearForm();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Clear Flight'),
                          ),
                        );
                      }),
                    ]);
              }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Builder(builder: (_) {
                      return TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount',
                          labelText: 'Add Funding',
                          suffix: Text('ETH'),
                        ),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: store
                                .etherAmountText(store.addAirlineFundingAmount),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
