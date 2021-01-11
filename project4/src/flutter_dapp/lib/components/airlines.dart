import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/airline_details.dart';
import 'package:flutter_dapp/components/date_input.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class AirlinePage extends StatefulWidget {
  @override
  _AirlinePageState createState() => _AirlinePageState();
}

class _AirlinePageState extends State<AirlinePage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
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
              SizedBox(
                height: 10,
              ),
              AirlineDetails(),
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
                        child: DropdownButtonFormField<Airport>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Departure Airport',
                          ),
                          isDense: true,
                          isExpanded: true,
                          value: null,
                          items: store.airportsDropdown(),
                          onChanged: (value) {
                            store.proposedFlight.setDepartureAirport(value);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<Airport>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Arrival Airport',
                          ),
                          isDense: true,
                          isExpanded: true,
                          value: null,
                          items: store.airportsDropdown(),
                          onChanged: (value) {
                            store.proposedFlight.setArrivalAirport(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DateTimeInput(),
              ),
              Row(
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    overflowDirection: VerticalDirection.down,
                    buttonPadding: EdgeInsets.all(20),
                    children: [
                      PermissionedButton(
                          requiredRole: ActorType.Airline,
                          action: () async {
                            store.isTransactionPending = true;
                            await store.registerAirline();
                            store.isTransactionPending = false;
                          },
                          buttonText: 'Register Airline',
                          disableCondition:
                              !store.selectedActor.isAirlineRegistered),
                      PermissionedButton(
                        requiredRole: ActorType.Airline,
                        action: () async {
                          store.isTransactionPending = true;
                          await store.fundAirline();
                          store.isTransactionPending = false;
                        },
                        buttonText: 'Fund Airline',
                      ),
                      PermissionedButton(
                          requiredRole: ActorType.Airline,
                          action: () async {
                            store.isTransactionPending = true;
                            await store.registerFlight();
                            store.isTransactionPending = false;
                          },
                          buttonText: 'Register Flight',
                          disableCondition:
                              !store.selectedActor.isAirlineFunded),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount',
                          labelText: 'Add Funding',
                          suffix: Text('ETH'),
                        ),
                        onChanged: (value) {
                          store.addAirlineFundingAmount =
                              EtherAmount.fromUnitAndValue(
                                  EtherUnit.ether, value ?? '0');
                        },
                        validator: (value) {
                          try {
                            BigInt.parse(value);
                          } catch (e) {
                            return 'Must be a number!';
                          }
                          return '';
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
