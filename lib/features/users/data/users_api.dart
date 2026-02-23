import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import 'models/album_model.dart';
import 'models/posts_model.dart';
import 'models/todo_model.dart';
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
}
