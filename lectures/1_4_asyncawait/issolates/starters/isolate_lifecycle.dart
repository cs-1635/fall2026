import 'dart:isolate';

/*
Exercise 3 — Isolate lifecycle (errors, exit, cancel)
Prompt:
- Spawn an isolate that:
  * emits a value, then throws an error, then emits a final 'done' (won't reach if not handled).
- In main:
  * Use ReceivePort for normal messages.
  * Use another ReceivePort for errors with Isolate.addErrorListener.
  * Use another ReceivePort for exit with Isolate.addOnExitListener.
- Observe error, then kill the isolate gracefully.
*/

Future<void> runExercise() async {
  // TODO: create message, error, and exit ports

  // TODO: spawn isolate, keep reference to Isolate

  // TODO: listen for first message, then wait for error, then kill isolate

  // TODO: close all ports
}

// TODO: worker function that sends one message, then throws


void main(List<String> args) async {
  runExample();
}