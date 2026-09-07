// Solution 01: Short-lived single-subscription stream (from Iterable)
Future<void> runExample() async {
  final s = Stream.fromIterable([1, 2, 3]);
  await for (final x in s) {
    print('got $x');
  }
  print('done');
}


void main(List<String> args) async {
  runExample();
}
  