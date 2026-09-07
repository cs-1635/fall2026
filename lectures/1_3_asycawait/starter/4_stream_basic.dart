// Goal: Build a stream that emits 1..N once per second and consume with `await for`.

Stream<int> countStream(int max) async* {
  // TODO: yield numbers from 1..max with a 1s delay each time
}

Future<void> main() async {
  // TODO: await for (final n in countStream(5)) { print(n); }
}
