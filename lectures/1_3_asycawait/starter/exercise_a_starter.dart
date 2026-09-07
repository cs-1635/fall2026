// Exercise A: Write doubleAfter1s that doubles x after 1s; call twice sequentially and time it.

Future<int> doubleAfter1s(int x) async {
  // TODO: delay 1s and return x * 2
  return x;
}

Future<void> main() async {
  final start = DateTime.now();
  final a = await doubleAfter1s(10);
  final b = await doubleAfter1s(a);
  final elapsed = DateTime.now().difference(start);
  print("Result=$b in ${elapsed.inMilliseconds}ms");
}
