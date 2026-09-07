Future<String> slowOperation() async {
  // Simulate a 1s delay
  await Future.delayed(Duration(seconds: 1));
  return "Done!";
}

Future<void> main() async {
  print("Calling slowOperation...");
  // TODO: Case 1 — call slowOperation() without await and print the variable
  // TODO: Case 2 — call slowOperation() with await and print the actual result
}
