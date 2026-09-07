import 'dart:isolate';

/*
Exercise 1 — Basic isolate spawn (one-way)
Prompt:
- Spawn an isolate that receives a string message and prints 'worker: <msg>'.
- From the main isolate, send 'hello from main' and then close.
- Use a ReceivePort to capture the worker's 'done' signal before exiting.
*/

Future<void> runExercise() async {
  // TODO: create a ReceivePort to get the worker's 'done' message

  // TODO: spawn an isolate, passing the SendPort of the ReceivePort and the message

  // TODO: listen for the 'done' message then close the ReceivePort
}

// TODO: write the entry function runWorker that accepts initial data and prints the message

void main(List<String> args) async {
  runExample();
}
