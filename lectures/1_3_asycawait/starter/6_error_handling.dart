// Goal: Show async error handling with try/catch.

Future<void> riskyTask() async {
  await Future.delayed(Duration(seconds: 1));
  // TODO: throw an Exception("Something went wrong!");
}

Future<void> main() async {
  // TODO: try { await riskyTask(); } catch (e) { print("Caught error: $e"); }
}
