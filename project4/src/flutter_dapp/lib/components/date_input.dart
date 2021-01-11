import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimeInput extends StatefulWidget {
  @override
  _DateTimeInputState createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _controllerTime = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMd();
    DateFormat timeFormat = DateFormat.jm();
    final store = Provider.of<ContractStore>(context);
    return Observer(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
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
                    text: store.selectedActor.actorName,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerDate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.calendar),
                  ),
                  labelText: 'Departure Date',
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  store.selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020, 12, 1),
                    lastDate: DateTime(2021, 12, 31),
                  );
                  _controllerDate.text = dateFormat.format(store.selectedDate);
                },
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerTime,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.clock,
                    ),
                  ),
                  labelText: 'Departure Time',
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  store.selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  _controllerTime.text = timeFormat.format(store.selectedDate
                      .add(Duration(
                          hours: store.selectedTime.hour,
                          minutes: store.selectedTime.minute)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
