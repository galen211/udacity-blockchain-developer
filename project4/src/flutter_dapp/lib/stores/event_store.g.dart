// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EventStore on _EventStoreBase, Store {
  final _$eventStreamAtom = Atom(name: '_EventStoreBase.eventStream');

  @override
  ObservableStream<dynamic> get eventStream {
    _$eventStreamAtom.reportRead();
    return super.eventStream;
  }

  @override
  set eventStream(ObservableStream<dynamic> value) {
    _$eventStreamAtom.reportWrite(value, super.eventStream, () {
      super.eventStream = value;
    });
  }

  final _$eventsAtom = Atom(name: '_EventStoreBase.events');

  @override
  ObservableList<FlightSuretyEvent> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<FlightSuretyEvent> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  final _$_EventStoreBaseActionController =
      ActionController(name: '_EventStoreBase');

  @override
  Widget eventToWidget(BuildContext context, int index) {
    final _$actionInfo = _$_EventStoreBaseActionController.startAction(
        name: '_EventStoreBase.eventToWidget');
    try {
      return super.eventToWidget(context, index);
    } finally {
      _$_EventStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
eventStream: ${eventStream},
events: ${events}
    ''';
  }
}
