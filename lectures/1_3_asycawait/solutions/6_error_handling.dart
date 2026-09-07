Future<void> riskyTask() async {
  await Future.delayed(Duration(seconds: 1));
  throw Exception("Something went wrong!");
}

Future<void> main() async {
  try {
    await riskyTask();
  } catch (e) {
    print("Caught error: $e");
  }
}
