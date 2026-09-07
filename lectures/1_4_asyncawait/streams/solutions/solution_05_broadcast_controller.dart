import 'dart:async';

// Solution 05: Broadcast controller with multiple listeners
Future<void> runExample() async {
  final controller = StreamController<int>.broadcast();

  controller.stream.listen((x) => print('A: $x'));
  Future.delayed(const Duration(milliseconds: 350), () {
    controller.stream.listen((x) => print('B: $x (late)'));
  });

  for (var i = 1; i <= 4; i++) {
    await Future.delayed(const Duration(milliseconds: 200));
    controller.add(i);
  }
  await controller.close();
}

void main(List<String> args) async {
  runExample();
}