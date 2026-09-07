import 'dart:async';

// Solution 02: Periodic stream with .take(5)
Future<void> runExample() async {
  final s = Stream.periodic(const Duration(milliseconds: 400), (i) => i).take(5);
  await for (final t in s) {
    print('tick $t');
  }
  print('complete');
}

void main(List<String> args) async {
  runExample();
}