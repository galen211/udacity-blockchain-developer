import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/airport.dart';
import 'package:flutter_dapp/stores/flight_data_store.dart';
import 'package:flutter_dapp/stores/flight_registration_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlightRegistrationForm extends StatefulWidget {
  @override
  _FlightRegistrationFormState createState() => _FlightRegistrationFormState();
}

class _FlightRegistrationFormState extends State<FlightRegistrationForm> {
  DateFormat dateFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FlightRegistrationStore>(context);
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Airline Code',
                      ),
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store?.airlineIata ?? '',
                              selection: TextSelection.collapsed(
                                  offset: store?.airlineIata?.length ?? 0))),
                      onChanged: (value) {
                        store.airlineIata = value;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Flight Number',
                      ),
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.flightNumber ?? '',
                              selection: TextSelection.collapsed(
                                  offset: store?.flightNumber?.length ?? 0))),
                      onChanged: (value) {
                        store.flightNumber = value;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    final data = Provider.of<FlightDataStore>(context);
                    return DropdownButtonFormField<Airport>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Departure Airport',
                      ),
                      isDense: true,
                      isExpanded: true,
                      value: store.departureAirport,
                      items: data.airports
                          .map((airport) => DropdownMenuItem<Airport>(
                                child: Text(airport.airportDescription),
                                value: airport,
                              ))
                          .toList(),
                      onChanged: (airport) {
                        store.departureAirport = airport;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    final data = Provider.of<FlightDataStore>(context);
                    return DropdownButtonFormField<Airport>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Arrival Airport',
                      ),
                      isDense: true,
                      isExpanded: true,
                      value: store.arrivalAirport,
                      items: data.airports
                          .map((airport) => DropdownMenuItem<Airport>(
                                child: Text(airport.airportDescription),
                                value: airport,
                              ))
                          .toList(),
                      onChanged: (airport) {
                        store.arrivalAirport = airport;
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.calendar),
                        ),
                        labelText: 'Departure Date',
                      ),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.departureDate == null
                              ? ''
                              : dateFormat.format(store.departureDate),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 90)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        store.departureDate = selectedDate;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
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
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: store.departureTime == null
                              ? ''
                              : store.departureTime.format(context),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: 18,
                            minute: 30,
                          ),
                        );
                        store.departureTime = selectedTime;
                      },
                    );
                  }),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Observer(builder: (_) {
                    return TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.stopwatch,
                          ),
                        ),
                        labelText: 'Departure Time (Millis)',
                      ),
                      readOnly: true,
                      controller: store.isValidSubmission
                          ? TextEditingController.fromValue(
                              TextEditingValue(
                                text: '${store.departureTimeMillis}',
                              ),
                            )
                          : TextEditingController.fromValue(
                              TextEditingValue(
                                text: '',
                              ),
                            ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
