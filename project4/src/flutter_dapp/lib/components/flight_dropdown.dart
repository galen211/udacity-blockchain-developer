import 'package:flutter/material.dart';

class FlightDropdown extends StatefulWidget {
  @override
  _FlightDropdownState createState() => _FlightDropdownState();
}

class _FlightDropdownState extends State<FlightDropdown> {
  String selected;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text("Choose Flight"),
      isDense: true,
      isExpanded: true,
      value: selected,
      items: ["A", "B", "C"]
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (value) {
        setState(() => selected = value);
      },
    );
  }
}
