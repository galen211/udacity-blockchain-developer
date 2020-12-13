import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Center(
              child: Text('Scenario Setup'),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'App Contract Address',
                suffixIcon: Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10,
                ),
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: '0xFA908234lkjj23lkj243'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Data Contract Address',
                suffixIcon: Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10,
                ),
              ),
              readOnly: true,
              controller: TextEditingController.fromValue(
                TextEditingValue(text: '0xFA908234lkjj23lkj243'),
              ),
            ),
            ButtonBar(
              overflowDirection: VerticalDirection.down,
              buttonPadding: EdgeInsets.all(20),
              children: [
                FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {},
                  child: Text('Disable App Contract'),
                ),
                FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {},
                  child: Text('Disable Data Contract'),
                ),
              ],
            ),
            Divider(),
            Text('Run Scenario Setup'),
            ButtonBar(
              overflowDirection: VerticalDirection.down,
              buttonPadding: EdgeInsets.all(20),
              children: [
                FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    //await store.getFlights();
                  },
                  child: Text('Setup Airline Consortium'),
                ),
                FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {},
                  child: Text('Register Flights'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
