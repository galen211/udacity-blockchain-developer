import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/data/actor.dart';
import 'package:provider/provider.dart';

class AirlineDetails extends StatefulWidget {
  @override
  _AirlineDetailsState createState() => _AirlineDetailsState();
}

class _AirlineDetailsState extends State<AirlineDetails> {
  //TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return StatefulBuilder(
      builder: (context, setState) => Column(
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
                        child: DropdownButtonFormField<Actor>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Select Airline',
                              hintText:
                                  'An airline or an unassigned account is required'),
                          isDense: true,
                          isExpanded: true,
                          value: null,
                          items: store.airlinesDropdown(),
                          onChanged: (value) {
                            setState(() {
                              store.selectedAirline = value;
                            });
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
                              color: store.selectedAirline.isAirlineRegistered
                                  ? Colors.green
                                  : Colors.red,
                              size: 10,
                            ),
                            suffixText:
                                store.selectedAirline.isAirlineRegistered
                                    ? 'Registered'
                                    : 'Not Registered',
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
                            setState(() {
                              store.selectedAirline.actorName = value;
                            });
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
                        text: store.airlineVotesString,
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
                        text: store.airlineFundingString,
                      ),
                    ),
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
