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

    DateTime departureDate;
    TimeOfDay departureTime;

    return Observer(
      builder: (context) {
        final store = Provider.of<ContractStore>(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
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
                    departureDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 12, 1),
                      lastDate: DateTime(2021, 12, 31),
                    );
                    store.proposedFlight.scheduledDeparture = departureDate;
                    _controllerDate.text = dateFormat.format(departureDate);
                  },
                ),
              ),
            ),
            Flexible(
              flex: 3,
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
                    departureTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    store.proposedFlight.scheduledDeparture.add(Duration(
                        hours: departureTime.hour,
                        minutes: departureTime.minute));
                    _controllerTime.text = timeFormat.format(departureDate.add(
                        Duration(
                            hours: departureTime.hour,
                            minutes: departureTime.minute)));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
