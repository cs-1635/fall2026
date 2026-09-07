Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return "Data loaded!";
}

Future<void> main() async {
  print("Start");
  final result = await fetchData();
  print(result);
  print("End");
}
