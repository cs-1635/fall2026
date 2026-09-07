Future<String> taskA() async {
  await Future.delayed(Duration(seconds: 2));
  return "A finished";
}

Future<String> taskB() async {
  await Future.delayed(Duration(seconds: 3));
  return "B finished";
}

Future<void> main() async {
  final start = DateTime.now();
  final results = await Future.wait([taskA(), taskB()]);
  final elapsed = DateTime.now().difference(start);
  print("Results: $results in ${elapsed.inMilliseconds}ms");
}
