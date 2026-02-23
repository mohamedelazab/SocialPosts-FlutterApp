class Endpoints {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  static const String users = "/users";
  static const String posts = "/posts";
  static const String comments = "/comments";
  static const String albums = "/albums";
  static const String photos = "/photos";
  static const String todos = "/todos";

  // User
  static String userById(int id) => "$users/$id";

  static String userPosts(int userId) => "$users/$userId/posts";

  static String userAlbums(int userId) => "$users/$userId/albums";

  static String userTodos(int userId) => "$users/$userId/todos";

  // Album
  static String albumPhotos(int albumId) => "$albums/$albumId/photos";

  // Post
  static String postComments(int postId) => "$posts/$postId/comments";
}
