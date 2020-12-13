import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/flight_dropdown.dart';

class OraclePage extends StatefulWidget {
  @override
  _OraclePageState createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Center(
              child: Text('Oracles'),
            ),
            FlightDropdown(),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Airline Address',
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: '0x4fda32klj4lk234l2l'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Airline Address',
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: '0x4fda32klj4lk234l2l'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Departure Time',
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: 'December 12, 2020 17:45'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Flight Status',
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: 'Unknown'),
              ),
            ),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Amount To Withdraw',
                labelText: 'Payout Amount',
                suffix: Text('ETH'),
              ),
            ),
            ButtonBar(
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
          ],
        ),
      ),
    );
  }
}
