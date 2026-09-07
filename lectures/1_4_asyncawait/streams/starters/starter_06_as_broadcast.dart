import 'dart:async';

// Starter 06: Convert single-sub stream to broadcast with asBroadcastStream
/*
Prompt:
- Make a base Stream.periodic that emits every 250ms and ends after 4 values.
- Convert it to broadcast via .asBroadcastStream().
- Attach L1 immediately, L2 after 300ms.
- Allow enough time for all events to print.
*/

Future<void> runExercise() async {
  // TODO: build base periodic stream and call .asBroadcastStream()

  // TODO: attach L1 now

  // TODO: attach L2 after 300ms

  // TODO: wait a bit so events can print
}

void main(List<String> args) async {
  runExample();
}
