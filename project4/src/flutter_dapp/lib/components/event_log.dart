import 'package:flutter/material.dart';
import 'package:flutter_dapp/stores/event_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EventLog extends StatefulWidget {
  @override
  _EventLogState createState() => _EventLogState();
}

class _EventLogState extends State<EventLog> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EventStore>(context);
    return Observer(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          child: ListView.builder(
              itemCount: store.events.length,
              itemBuilder: (BuildContext context, int index) {
                return store.eventToWidget(context, index);
              }),
        );
      },
    );
  }
}
