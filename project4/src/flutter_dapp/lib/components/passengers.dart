import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dapp/components/flight_selected.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'flight_table.dart';

class PassengerPage extends StatefulWidget {
  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
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
                builder: (context) => store.registeredFlights.length < 1
                    ? Container(
                        child: Center(
                          child: Text("No flights are currently registered"),
                        ),
                      )
                    : FlightTable(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                ButtonBar(
                  overflowDirection: VerticalDirection.down,
                  buttonPadding: EdgeInsets.all(20),
                  children: [
                    FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        store.getFlights();
                      },
                      child: Text('Get Flights'),
                    ),
                    FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () {},
                      child: Text('Buy Insurance'),
                    ),
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
                        labelText: 'Insurance Amount',
                        suffix: Text('ETH'),
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        double amount;
                        try {
                          amount = double.parse(value);
                        } catch (e) {
                          return 'Must be a number!';
                        }
                        if (amount > 1)
                          return "Cannot purchase more than 1 ETH insurance";
                        return "";
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: FlightSelected(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
