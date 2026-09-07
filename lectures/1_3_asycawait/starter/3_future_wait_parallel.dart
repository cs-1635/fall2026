// Goal: Run two async tasks in parallel and measure total time.
// Replace TODOs and verify total time ~= longest task.

Future<String> taskA() async {
  // Simulate 2s
  // TODO
  return "A finished";
}

Future<String> taskB() async {
  // Simulate 3s
  // TODO
  return "B finished";
}

Future<void> main() async {
  final start = DateTime.now();
  // TODO: await Future.wait([...]) for taskA() and taskB()
  // print results and elapsed time
}
