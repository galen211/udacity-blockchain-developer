import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/actor_store.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AirlineDetails extends StatefulWidget {
  @override
  _AirlineDetailsState createState() => _AirlineDetailsState();
}

class _AirlineDetailsState extends State<AirlineDetails> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final store = Provider.of<ContractStore>(context);
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<ActorStore>(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Select Airline',
                                hintText:
                                    'An airline or an unassigned account is required'),
                            isDense: true,
                            isExpanded: true,
                            value: null,
                            items: store.airlines
                                .map((airline) => DropdownMenuItem<ActorStore>(
                                      child: Text(airline.actorName),
                                      value: airline,
                                    ))
                                .toList(),
                            onChanged: (airline) {
                              debugPrint(
                                  'selectedAirline: ${airline.actorName}');
                              store.selectedAirline = airline;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rename Airline',
                              suffixIcon: Icon(
                                Icons.circle,
                                color:
                                    store.selectedAirline.airlineMembership ==
                                            Membership.Funded
                                        ? Colors.green
                                        : Colors.red,
                                size: 10,
                              ),
                              suffixText: store
                                  .selectedAirline.airlineMembership
                                  .membershipDescription(),
                            ),
                            readOnly: false,
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: store.selectedAirline.actorName,
                                  selection: TextSelection.collapsed(
                                      offset: store
                                          .selectedAirline.actorName.length)),
                            ),
                            onChanged: (value) {
                              store.selectedAirline.actorName = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 2,
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
                          text: store.selectedAirline.address.hex,
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
                        labelText: 'Number of Votes',
                      ),
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: '${store.selectedAirline.airlineVotes}',
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
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.etherAmountText(
                              store.selectedAirline.airlineFunding),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
