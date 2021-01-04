import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';

Stream<int> timedCounter(Duration interval,
    {int maxCount = 10, int start = 0}) async* {
  int i = start;
  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == start + maxCount) break;
  }
}

void main() async {
  StreamGroup streamGroup;
  StreamController controller;

  setUpAll(() async {
    streamGroup = StreamGroup();
    controller = StreamController();
  });

  test("Setup multiple streams", () async {
    [1, 5, 10, 25, 50, 100].forEach((i) {
      Stream t = timedCounter(Duration(milliseconds: 100), start: i);
      streamGroup.add(t);
    });

    streamGroup.add(controller.stream);

    Future.delayed(Duration(milliseconds: 1000),
            () => controller.sink.addError("manual error"))
        .then((_) => controller.close());

    // var subscription = streamGroup.stream.listen(
    //   (event) {
    //     print(event);
    //   },
    //   onError: (e) {
    //     print("stream error $e");
    //   },
    //   onDone: () {
    //     print("stream done");
    //   },
    //   cancelOnError: false,
    // );

    await streamGroup.close();
  });
}
