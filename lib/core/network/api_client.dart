import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  Future<List<dynamic>> getList(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse("${Endpoints.baseUrl}$path")
        .replace(queryParameters: query);

    if (kDebugMode) {
      print("REQUEST URL: $uri");
    }

    final response = await _client.get(
      uri,
      headers: {
        "Accept": "application/json",
        "User-Agent": "FlutterApp",
      },
    );

    if (kDebugMode) {
      print("STATUS CODE: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.statusCode}");
    }
  }



  Future<Map<String, dynamic>> getItem(String path) async {
    final uri = Uri.parse("${Endpoints.baseUrl}$path");

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error");
    }
  }
}
