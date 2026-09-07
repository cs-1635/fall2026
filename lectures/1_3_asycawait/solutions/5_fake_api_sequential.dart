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

  // Sequential
  final user = await fetchUser();
  final posts = await fetchPosts();
  print(user);
  print(posts);

  // Extension: parallel
  // final results = await Future.wait([fetchUser(), fetchPosts()]);
  // print(results);
}
