import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract/contract_store.dart';
import 'package:flutter_dapp/data/flight.dart';
import 'package:flutter_dapp/data/flight_data_source.dart';
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
    FlightDataSource _dataSource =
        FlightDataSource(flights: store.registeredFlights.toList());

    return Container(
      child: SfDataGrid(
        controller: controller,
        columnWidthMode: ColumnWidthMode.fill,
        columns: [
          GridTextColumn(
              mappingName: 'flightIata',
              headerText: 'Flight',
              columnWidthMode: ColumnWidthMode.auto),
          GridTextColumn(
              mappingName: 'airlineName',
              headerText: 'Airline',
              columnWidthMode: ColumnWidthMode.auto),
          GridTextColumn(
              mappingName: 'departureAirportString', headerText: 'From'),
          GridTextColumn(mappingName: 'arrivalAirportString', headerText: 'To'),
          GridDateTimeColumn(
              allowSorting: true,
              mappingName: 'scheduledDeparture',
              headerText: 'Departs At',
              dateFormat: DateFormat.yMd().add_jm(),
              columnWidthMode: ColumnWidthMode.auto),
          GridDateTimeColumn(
              allowSorting: true,
              mappingName: 'scheduledArrival',
              headerText: 'Arrives At',
              dateFormat: DateFormat.yMd().add_jm(),
              columnWidthMode: ColumnWidthMode.auto),
          GridTextColumn(
              mappingName: 'status',
              headerText: 'Status',
              columnWidthMode: ColumnWidthMode.auto),
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
              store.selectedFlight = Flight();
            }
          });
        },
        allowSorting: true,
      ),
    );
  }
}
