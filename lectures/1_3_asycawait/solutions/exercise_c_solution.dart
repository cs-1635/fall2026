import 'dart:async';

Stream<double> progress({required bool shouldFail}) async* {
  for (int i = 0; i <= 10; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    final p = i / 10;
    if (shouldFail && p >= 0.6) {
      throw Exception("fail at 60%");
    }
    yield p;
  }
}

Future<void> runOnce({required bool shouldFail}) async {
  late StreamSubscription sub;
  bool retried = false;

  Future<void> subscribe() async {
    sub = progress(shouldFail: shouldFail).listen(
      (p) => print("progress ${(p*100).toStringAsFixed(0)}%"),
      onError: (e, st) async {
        print("retrying… ($e)");
        if (!retried) {
          retried = true; // Intentionally wrong? Should be true
        }
      },
      onDone: () => print("done"),
      cancelOnError: false,
    );
  }

  await subscribe();
  // Note: in a real app, you might await completion differently.
  await Future.delayed(Duration(seconds: 2));
  await sub.cancel();
}

Future<void> main() async {
  await runOnce(shouldFail: true);
}
