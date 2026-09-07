Future<String> slowOperation() async {
  await Future.delayed(Duration(seconds: 1));
  return "Done!";
}

Future<void> main() async {
  print("Calling slowOperation...");
  final futureResult = slowOperation();          // no await
  print("Not waiting: $futureResult");           // prints Instance of 'Future<String>'

  final actualResult = await slowOperation();    // with await
  print("Waiting: $actualResult");
}
