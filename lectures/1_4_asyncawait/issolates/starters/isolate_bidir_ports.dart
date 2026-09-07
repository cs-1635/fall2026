import 'dart:isolate';

/*
Exercise 2 — Bidirectional messaging
Prompt:
- Main creates ReceivePort (mainPort).
- Spawn worker with mainPort.sendPort.
- In worker: create its own ReceivePort, send its SendPort back to main.
- Exchange messages: main sends 'ping', worker replies 'pong', then both shut down.
*/

Future<void> runExercise() async {
  // TODO: main ReceivePort
  // final mainPort = ...

  // TODO: spawn isolate with mainPort.sendPort

  // TODO: wait for worker to send back its SendPort

  // TODO: send 'ping' to worker and wait for 'pong'

  // TODO: cleanup ports
}

// TODO: worker entry function

void main(List<String> args) async {
  runExample();
}
