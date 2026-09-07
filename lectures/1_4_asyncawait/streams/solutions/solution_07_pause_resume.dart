import 'dart:async';

// Solution 07: Pause/resume a subscription
Future<void> runExample() async {
  final s = Stream.periodic(const Duration(milliseconds: 150), (i) => i).take(6);
  StreamSubscription<int>? sub;
  sub = s.listen((x) async {
    print('got $x');
    if (x == 2 && sub != null) {
      print('pause...');
      sub!.pause();
      await Future.delayed(const Duration(milliseconds: 500));
      print('resume');
      sub!.resume();
    }
  }, onDone: () => print('done'));

  await sub.asFuture<void>();
}


void main(List<String> args) async {
  runExample();
}