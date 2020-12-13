import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateTimeInput extends StatefulWidget {
  @override
  _DateTimeInputState createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _controllerTime = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controllerDate,
            decoration: InputDecoration(
              suffixIcon: FaIcon(FontAwesomeIcons.calendar),
              labelText: 'Departure Date',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020, 12, 1),
                lastDate: DateTime(2021, 12, 31),
              );
              _controllerDate.text = date.toIso8601String();
              debugPrint('Selected date: ${date.toIso8601String()}');
            },
          ),
        ),
        Expanded(
          child: TextField(
            controller: _controllerTime,
            decoration: InputDecoration(
              suffixIcon: FaIcon(FontAwesomeIcons.clock),
              labelText: 'Departure Time',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              _controllerTime.text = time.toString();
              debugPrint('Selected time: ${time.toString()}');
            },
          ),
        ),
      ],
    );
  }
}
