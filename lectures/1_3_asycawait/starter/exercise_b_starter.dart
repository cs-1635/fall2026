// Exercise B: Run two doubleAfter1s calls in parallel and sum results.

Future<int> doubleAfter1s(int x) async {
  await Future.delayed(Duration(seconds: 1));
  return x * 2;
}

Future<void> main() async {
  final start = DateTime.now();
  // TODO: use Future.wait on [doubleAfter1s(10), doubleAfter1s(20)]
  // then sum and print time
}
