import 'dart:async';

// Starter 05: Broadcast controller with late subscriber
/*
Prompt:
- Create a StreamController<int>.broadcast().
- Subscribe listener A immediately (prints 'A: <x>').
- Subscribe listener B after ~350ms (prints 'B: <x> (late)').
- Produce 4 values spaced ~200ms apart, then close the controller.
- Observe that B misses the early events (hot stream).
*/

Future<void> runExercise() async {
  // TODO: create broadcast controller
  // final controller = ...

  // TODO: listener A

  // TODO: delayed listener B

  // TODO: producer loop (4 values, 200ms apart), then close
}

void main(List<String> args) async {
  runExample();
}