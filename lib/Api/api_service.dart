import 'package:hocflutter/Api/models/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://napro-api.azurewebsites.net/api';
  Future<ApiResponse> sendTokenToApi(String token) async {
    final response = await http.post(
      Uri.parse('https://napro-api.azurewebsites.net/api/users/oauth2-google'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'token': token}),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(
        statusCode: response.statusCode,
        message: 'Request failed with status: ${response.statusCode}',
        totalRecord: 0,
        data: null,
      );
    }
  }

  Future<ApiResponse> fetchTasks(String accessToken) async {
    final url = Uri.parse('$_baseUrl/tasks?StartDate=2024-01-01&EndDate=2024-01-02&ForMe=false');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

}

