// Solution 03: map → where → takeWhile
Future<void> runExample() async {
  final s = Stream.fromIterable([10, 15, 22, 30, 41])
      .map((x) => x * 2)        // 20, 30, 44, 60, 82
      .where((x) => x.isEven)   // keep evens
      .takeWhile((x) => x < 60);// 20, 30, 44

  await for (final v in s) {
    print(v);
  }
  print('done');
}


void main(List<String> args) async {
  runExample();
}