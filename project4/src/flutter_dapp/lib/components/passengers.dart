import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/contract/flight.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PassengerPage extends StatefulWidget {
  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  int _selectedItem;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Flights",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Expanded(
              child: Observer(
                builder: (context) => store.registeredFlights.length < 1
                    ? Container(
                        child: Center(
                          child: Text("No flights are currently registered"),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            padding: EdgeInsets.all(5),
                            shrinkWrap: true,
                            itemCount: store.registeredFlights.length,
                            itemBuilder: (BuildContext context, int index) {
                              Flight flight = store.registeredFlights[index];
                              return ListTile(
                                hoverColor: Colors.white70,
                                isThreeLine: true,
                                selected: _selectedItem == index,
                                onTap: () {
                                  setState(() {
                                    _selectedItem = index;
                                  });
                                },
                                contentPadding: EdgeInsets.all(5),
                                leading: Icon(Icons.flight),
                                title: Text(flight.flightName),
                                subtitle: Text(
                                    'Departure time: ${flight.departureTime}'),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Row(
              children: [
                ButtonBar(
                  overflowDirection: VerticalDirection.down,
                  buttonPadding: EdgeInsets.all(20),
                  children: [
                    FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        await store.getFlights();
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: Center(
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
                      },
                    ),
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
