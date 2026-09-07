// Capstone: Parallel-load user, posts, notifications; progress stream; handle errors; timeout at 2.2s

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
  // TODO: consume increments from completed and yield soFar/total
}

Future<void> main() async {
  final completed = StreamController<int>();
  final total = 3;

  final userF = fetchUser().whenComplete(() => completed.add(1));
  final postsF = fetchPosts().whenComplete(() => completed.add(1));
  final notifF = fetchNotifications()
      // TODO: catchError to turn failure into 0
      .whenComplete(() => completed.add(1));

  // TODO: listen to progress(...) and print percentages

  try {
    // TODO: await Future.wait([...]).timeout(Duration(milliseconds: 2200))
  } on TimeoutException {
    print("timeout — using cached view");
    print(["User:Cached","[P1]","0 notifs"]);
  } finally {
    // TODO: cancel progress subscription and close controller
  }
}
