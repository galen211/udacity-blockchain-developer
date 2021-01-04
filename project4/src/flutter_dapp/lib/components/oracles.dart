import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'event_log.dart';
import 'flight_selected.dart';

class OraclePage extends StatefulWidget {
  @override
  _OraclePageState createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> {
  DateFormat formatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                'Monitor Flight Status',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlightSelected(),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Airline Address',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: store.selectedFlight.airlineAddress == null
                                ? ''
                                : store.selectedFlight.airlineAddress.hex,
                          ),
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
                          labelText: 'Airline Name',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.selectedFlight.airlineName ?? ''),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                          labelText: 'Departure Time',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.selectedFlight.scheduledDeparture ==
                                      null
                                  ? ''
                                  : formatter.format(
                                      store.selectedFlight.scheduledDeparture)),
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
                          labelText: 'Flight Status',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.selectedFlight.status == null
                                  ? ''
                                  : store.selectedFlight.getStatus()),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount To Withdraw',
                          labelText: 'Payout Amount',
                          suffix: Text('ETH'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: ButtonBar(
                      overflowDirection: VerticalDirection.down,
                      buttonPadding: EdgeInsets.all(20),
                      children: [
                        FlatButton(
                          color: Colors.blueAccent,
                          onPressed: () async {
                            //await store.getFlights();
                          },
                          child: Text('Check Flight Status'),
                        ),
                        FlatButton(
                          color: Colors.blueAccent,
                          onPressed: () {},
                          child: Text('Check Insurance Payout'),
                        ),
                        FlatButton(
                          color: Colors.blueAccent,
                          onPressed: () {},
                          child: Text('Withdraw Payout'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
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
    );
  }
}
