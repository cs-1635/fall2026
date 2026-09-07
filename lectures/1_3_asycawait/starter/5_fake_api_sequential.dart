// Goal: Simulate sequential API calls; then try parallel with Future.wait as an extension.

Future<String> fetchUser() async {
  await Future.delayed(Duration(seconds: 2));
  return "User: Parker";
}

Future<String> fetchPosts() async {
  await Future.delayed(Duration(seconds: 3));
  return "Posts: [Post1, Post2]";
}

Future<void> main() async {
  print("Loading profile...");
  // TODO: Fetch user then posts (sequential). Print both.
  // EXT: Use Future.wait([fetchUser(), fetchPosts()]) to fetch in parallel.
}
