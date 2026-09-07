Future<int> doubleAfter1s(int x) async {
  await Future.delayed(Duration(seconds: 1));
  return x * 2;
}

Future<void> main() async {
  final start = DateTime.now();
  final results = await Future.wait([
    doubleAfter1s(10),
    doubleAfter1s(20),
  ]);
  final sum = results.reduce((a,b) => a+b);
  final elapsed = DateTime.now().difference(start);
  print("sum=$sum in ${elapsed.inMilliseconds}ms");
}
