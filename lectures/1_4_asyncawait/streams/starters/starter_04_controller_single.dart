import 'dart:async';

// Starter 04: StreamController with error handling
/*
Prompt:
- Create a StreamController<int> (single-subscription).
- Add values 1 and 2, then addError('whoops'), then 3, then close the controller.
- Listen with onData, onError, onDone and ensure cancelOnError is false so the stream continues after error.
- Wait for completion.
*/

Future<void> runExercise() async {
  // TODO: create controller
  // final controller = ...

  // TODO: producer adds values + error + close
  // () async { ... }();

  // TODO: listen with onData/onError/onDone; cancelOnError: false
  // final sub = controller.stream.listen(...);

  // TODO: await sub.asFuture<void>();
}

void main(List<String> args) async {
  runExample();
}