import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import 'models/user_model.dart';

class UsersApi {
  final ApiClient _apiClient;

  UsersApi() : _apiClient = ApiClient(http.Client());

  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.getList(Endpoints.users);

    return response
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
  }
}
