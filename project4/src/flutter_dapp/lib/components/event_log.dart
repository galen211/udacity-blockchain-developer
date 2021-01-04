import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class EventLog extends StatefulWidget {
  @override
  _EventLogState createState() => _EventLogState();
}

class _EventLogState extends State<EventLog> {
  TreeController _controller = TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
        child: SingleChildScrollView(
          child: TreeView(
            treeController: _controller,
            nodes: [
              EventLogEntry(
                      eventName: 'Register Airline',
                      childText: 'Cathay Pacific')
                  .event,
              EventLogEntry(
                      eventName: 'Register Airline',
                      childText: 'British Airways')
                  .event,
              EventLogEntry(
                      eventName: 'Register Airline',
                      childText: 'All Nippon Airways')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'CX272 HKG-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'DL52 SFO-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'BA252 LHR-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'NH527 NRT-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'NH527 NRT-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'NH527 NRT-JFK')
                  .event,
              EventLogEntry(
                      eventName: 'Register Flight', childText: 'NH527 NRT-JFK')
                  .event,
            ],
          ),
        ),
      ),
    );
  }
}

class EventLogEntry extends TreeNode {
  String eventName;
  String childText;
  TreeNode event;

  EventLogEntry({@required this.eventName, @required this.childText}) {
    event = TreeNode(
      content: Expanded(
        flex: 10,
        child: Card(
          elevation: 8,
          color: Colors.blueAccent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Text(eventName),
          ),
        ),
      ),
      children: [
        TreeNode(
          content: Text(childText),
        ),
      ],
    );
  }
}
