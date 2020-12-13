import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/date_input.dart';

class AirlinePage extends StatefulWidget {
  @override
  _AirlinePageState createState() => _AirlinePageState();
}

class _AirlinePageState extends State<AirlinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Airlines',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
            "Airline Details",
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Airline Address',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Airline Name',
            ),
          ),
          Text("Airline Funding"),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Funding Amount',
              suffix: Text('ETH'),
            ),
          ),
          Text("Register Flight"),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Flight Airline',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Funding Name',
              suffix: Text('ETH'),
            ),
          ),
          DateTimeInput(),
          ButtonBar(
            overflowDirection: VerticalDirection.down,
            buttonPadding: EdgeInsets.all(20),
            children: [
              FlatButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  //await store.getFlights();
                },
                child: Text('Register Airline'),
              ),
              FlatButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child: Text('Fund Airline'),
              ),
              FlatButton(
                color: Colors.blueAccent,
                onPressed: () {},
                child: Text('Register Flight'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
