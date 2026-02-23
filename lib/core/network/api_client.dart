import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  // ================= COMMON GET METHOD =================

  Future<http.Response> _getRequest(
      String path, {
        Map<String, String>? query,
      }) async {
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

    return response;
  }

  // ================= GET LIST =================

  Future<List<dynamic>> getList(
      String path, {
        Map<String, String>? query,
      }) async {
    final response = await _getRequest(path, query: query);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        "API Error (${response.statusCode}): ${response.body}",
      );
    }
  }

  // ================= GET SINGLE ITEM =================

  Future<Map<String, dynamic>> getItem(
      String path, {
        Map<String, String>? query,
      }) async {
    final response = await _getRequest(path, query: query);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "API Error (${response.statusCode}): ${response.body}",
      );
    }
  }
}