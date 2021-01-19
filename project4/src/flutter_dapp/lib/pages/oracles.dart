import 'package:flutter/material.dart';
import 'package:flutter_dapp/components/event_log.dart';
import 'package:flutter_dapp/components/flight_selected.dart';
import 'package:flutter_dapp/components/permissioned_button.dart';
import 'package:flutter_dapp/data/enums.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OraclePage extends StatefulWidget {
  @override
  _OraclePageState createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> {
  DateFormat formatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              'Monitor Flight Status',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlightSelected(),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Airline Address',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: store.selectedFlight.airlineAddress == null
                                ? ''
                                : store.selectedFlight.airlineAddress.hex,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Airline Name',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.selectedFlight.airlineName ?? ''),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Departure Time',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: store.selectedFlight.scheduledDeparture ==
                                      null
                                  ? ''
                                  : formatter.format(
                                      store.selectedFlight.scheduledDeparture)),
                        ),
                      );
                    }),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Flight Status',
                        ),
                        readOnly: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text:
                                store.selectedFlight.flightStatus.description(),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount To Withdraw',
                          labelText: 'Payout Amount',
                          suffix: Text('ETH'),
                        ),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text:
                                store.etherAmountText(store.withdrawablePayout),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Observer(builder: (_) {
                    return ButtonBar(
                      overflowDirection: VerticalDirection.down,
                      buttonPadding: EdgeInsets.all(20),
                      children: [
                        PermissionedButton(
                          requiredRole: ActorType.Passenger,
                          action: () {
                            store.checkFlightStatus();
                          },
                          buttonText: 'Check Flight Status',
                          disableCondition: store.isTransactionPending,
                        ),
                        PermissionedButton(
                          requiredRole: ActorType.Passenger,
                          action: () {
                            store.withdrawAvailableBalance();
                          },
                          buttonText: 'Withdraw Payout',
                          disableCondition: store.isTransactionPending,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: EventLog(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
