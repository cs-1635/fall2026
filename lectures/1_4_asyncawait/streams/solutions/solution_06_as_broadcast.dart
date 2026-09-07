import 'dart:async';

Stream<int> _makeSharedCounter() {
  final base = Stream.periodic(const Duration(milliseconds: 250), (i) => i).take(4);
  return base.asBroadcastStream();
}

Future<void> runExample() async {
  final shared = _makeSharedCounter();

  shared.listen((x) => print('L1: $x'));
  await Future.delayed(const Duration(milliseconds: 300));
  shared.listen((x) => print('L2: $x (late)'));

  await Future.delayed(const Duration(seconds: 2));
}

void main(List<String> args) async {
  runExample();
}
