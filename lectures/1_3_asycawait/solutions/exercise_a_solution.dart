Future<int> doubleAfter1s(int x) async {
  await Future.delayed(Duration(seconds: 1));
  return x * 2;
}

Future<void> main() async {
  final start = DateTime.now();
  final a = await doubleAfter1s(10); // ~1s
  final b = await doubleAfter1s(a);  // ~1s
  final elapsed = DateTime.now().difference(start);
  print("Result=$b in ${elapsed.inMilliseconds}ms");
}
