import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/data/events.dart';
import 'package:flutter_dapp/prerequisites.dart';
import 'package:flutter_dapp/stores/contract_service.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts.dart';

part 'event_store.g.dart';

class EventStore = _EventStoreBase with _$EventStore;

abstract class _EventStoreBase with Store {
  Prerequisites prerequisites;

  Map<EventType, ContractEvent> contractEvents;
  ContractService service;

  StreamGroup<FlightSuretyEvent> streamGroup;
  StreamSubscription<FlightSuretyEvent> subscription;

  @observable
  ObservableStream eventStream;

  @observable
  ObservableList<FlightSuretyEvent> events =
      ObservableList<FlightSuretyEvent>();

  _EventStoreBase() {
    prerequisites = Prerequisites();
    contractEvents = prerequisites.contractEvents;
    service = ContractService();
    setupStreams();
  }

  @action
  Widget eventToWidget(BuildContext context, int index) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              events[index].eventType.eventName(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              width: 20,
            ),
            SelectableText(
              events[index].description(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }

  void setupStreams() {
    streamGroup = StreamGroup();

    contractEvents.forEach((eventType, contractEvent) {
      Stream<FlightSuretyEvent> stream = service
          .registerStream(contractEvent)
          .map((List<dynamic> decodedData) {
        FlightSuretyEvent event = FlightSuretyEvent(eventType, decodedData);
        return event;
      });
      streamGroup.add(stream);
    });

    eventStream = streamGroup.stream.asObservable();

    subscription = streamGroup.stream.listen(
      (FlightSuretyEvent event) {
        events.add(event);
        debugPrint("Event: ${event.description()}");
      },
      onError: (e) {
        debugPrint("Stream Error ${e.toString()}");
      },
      onDone: () {
        debugPrint("Stream Done");
        subscription.cancel();
      },
      cancelOnError: false,
    );
  }
}
