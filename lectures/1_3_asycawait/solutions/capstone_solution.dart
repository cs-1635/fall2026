import 'dart:async';

Future<String> fetchUser() async {
  await Future.delayed(Duration(milliseconds: 1500));
  return "User:Parker";
}

Future<List<String>> fetchPosts() async {
  await Future.delayed(Duration(seconds: 2));
  return ["P1","P2","P3"];
}

Future<int> fetchNotifications() async {
  await Future.delayed(Duration(milliseconds: 300));
  throw Exception("Notif service down");
}

Stream<double> progress(int total, Stream<int> completed) async* {
  int soFar = 0;
  await for (final inc in completed) {
    soFar += inc;
    yield soFar / total;
  }
}

Future<void> main() async {
  final completed = StreamController<int>();
  final total = 3;

  final userF = fetchUser().whenComplete(() => completed.add(1));
  final postsF = fetchPosts().whenComplete(() => completed.add(1));
  final notifF = fetchNotifications()
      .catchError((e) {
        print("notifications error: $e");
        return 0;
      })
      .whenComplete(() => completed.add(1));

  final prog = progress(total, completed.stream).listen(
    (p) => print("progress ${(p * 100).toStringAsFixed(0)}%"),
  );

  try {
    final result = await Future.wait([userF, postsF, notifF])
        .timeout(Duration(milliseconds: 2200));
    print("loaded: $result");
  } on TimeoutException {
    print("timeout — using cached view");
    print(["User:Cached","[P1]","0 notifs"]);
  } finally {
    await prog.cancel();
    await completed.close();
  }
}
