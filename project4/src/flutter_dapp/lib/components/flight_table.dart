import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/flight_data_source.dart';
import 'package:flutter_dapp/stores/contract_store.dart';
import 'package:flutter_dapp/stores/flight_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FlightTable extends StatefulWidget {
  @override
  _FlightTableState createState() => _FlightTableState();
}

class _FlightTableState extends State<FlightTable> {
  DataGridController controller = DataGridController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ContractStore>(context);
    FlightDataSource _dataSource = FlightDataSource(
        flights:
            store.flights.values.where((flight) => flight.registered).toList());

    return Container(
      child: SfDataGrid(
        controller: controller,
        columnWidthMode: ColumnWidthMode.fill,
        columns: [
          GridTextColumn(
              mappingName: 'flightIata',
              headerText: 'Flight',
              columnWidthMode: ColumnWidthMode.fill),
          GridTextColumn(
              mappingName: 'airlineName',
              headerText: 'Airline',
              columnWidthMode: ColumnWidthMode.fill),
          GridTextColumn(
              mappingName: 'departureAirportString', headerText: 'From'),
          GridTextColumn(mappingName: 'arrivalAirportString', headerText: 'To'),
          GridDateTimeColumn(
              allowSorting: true,
              mappingName: 'scheduledDeparture',
              headerText: 'Departs At',
              dateFormat: DateFormat.yMd().add_jm(),
              columnWidthMode: ColumnWidthMode.fill),
          GridDateTimeColumn(
              allowSorting: true,
              mappingName: 'scheduledArrival',
              headerText: 'Arrives At',
              dateFormat: DateFormat.yMd().add_jm(),
              columnWidthMode: ColumnWidthMode.fill),
          GridTextColumn(
              mappingName: 'status',
              headerText: 'Status',
              columnWidthMode: ColumnWidthMode.fill),
        ],
        source: _dataSource,
        selectionMode: SelectionMode.singleDeselect,
        navigationMode: GridNavigationMode.row,
        selectionManager: RowSelectionManager(),
        onSelectionChanged: (addedRows, removedRows) {
          setState(() {
            if (addedRows.length > 0) {
              store.selectedFlight = addedRows[0];
            } else {
              store.selectedFlight = FlightStore();
            }
          });
        },
        allowSorting: true,
      ),
    );
  }
}
