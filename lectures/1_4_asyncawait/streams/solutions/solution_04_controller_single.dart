import 'dart:async';

// Solution 04: StreamController (single-sub), error handling, close
Future<void> runExample() async {
  final controller = StreamController<int>();

  // Producer
  () async {
    controller.add(1);
    controller.add(2);
    controller.addError('whoops');
    controller.add(3);
    await controller.close();
  }();

  // Consumer with error handling
  final sub = controller.stream.listen(
    (x) => print('value: $x'),
    onError: (e, st) => print('handled error: $e'),
    onDone: () => print('done'),
    cancelOnError: false,
  );

  await sub.asFuture<void>();
}


void main(List<String> args) async {
  runExample();
}
