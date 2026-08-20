import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../../profile/data/models/album_model.dart';
import '../../profile/data/models/comment_model.dart';
import '../../profile/data/models/photo_model.dart';
import '../../profile/data/models/posts_model.dart';
import '../../profile/data/models/todo_model.dart';
import 'models/user_model.dart';

class UsersApi {
  final ApiClient _apiClient;

  UsersApi() : _apiClient = ApiClient(http.Client());

  // ================= USERS =================

  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.getList(Endpoints.users);

    return response.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel> getUserById(int id) async {
    final response = await _apiClient.getItem(Endpoints.userById(id));

    return UserModel.fromJson(response);
  }

  // ================= POSTS =================

  Future<List<PostModel>> getAllPosts() async {
    final response = await _apiClient.getList(Endpoints.posts);

    return response.map<PostModel>((json) => PostModel.fromJson(json)).toList();
  }

  Future<PostModel> getPostById(int postId) async {
    final response = await _apiClient.getItem(Endpoints.postById(postId));

    return PostModel.fromJson(response);
  }

  Future<List<CommentModel>> getPostComments(int postId) async {
    final response = await _apiClient.getList(Endpoints.postComments(postId));

    return response
        .map<CommentModel>((json) => CommentModel.fromJson(json))
        .toList();
  }

  /// All comments across every post — used by the Feed to compute a
  /// per-post comment count without an N+1 request per card.
  Future<List<CommentModel>> getAllComments() async {
    final response = await _apiClient.getList(Endpoints.comments);

    return response
        .map<CommentModel>((json) => CommentModel.fromJson(json))
        .toList();
  }

  // ================= USER RELATED DATA =================

  Future<List<PostModel>> getUserPosts(int userId) async {
    final response = await _apiClient.getList(Endpoints.userPosts(userId));

    return response.map<PostModel>((json) => PostModel.fromJson(json)).toList();
  }

  Future<List<AlbumModel>> getUserAlbums(int userId) async {
    final response = await _apiClient.getList(Endpoints.userAlbums(userId));

    return response
        .map<AlbumModel>((json) => AlbumModel.fromJson(json))
        .toList();
  }

  Future<List<TodoModel>> getUserTodos(int userId) async {
    final response = await _apiClient.getList(Endpoints.userTodos(userId));

    return response.map<TodoModel>((json) => TodoModel.fromJson(json)).toList();
  }

  Future<List<PhotoModel>> getAlbumPhotos(int albumId) async {
    final response = await _apiClient.getList(Endpoints.albumPhotos(albumId));
    return response
        .map<PhotoModel>((json) => PhotoModel.fromJson(json))
        .toList();
  }
}
