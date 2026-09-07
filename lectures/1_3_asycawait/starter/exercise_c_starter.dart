// Exercise C: Build a progress() stream 0.0 -> 1.0 in 10 steps (100ms apart).
// If shouldFail is true, throw at 0.6. Subscribe, print percentages,
// on error: print "retrying..." and re-subscribe once.

import 'dart:async';

Stream<double> progress({required bool shouldFail}) async* {
  // TODO: implement
}

Future<void> main() async {
  // TODO: subscribe to progress(shouldFail: true/false)
}
