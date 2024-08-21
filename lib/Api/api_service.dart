import 'package:hocflutter/Api/models/ApiResponse.dart';
import 'package:hocflutter/Api/models/task.dart';
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

  Future<List<Task>> fetchTasks(
      String accessToken, DateTime startDate, DateTime endDate) async {
    final url = Uri.parse(
      '$_baseUrl/tasks?StartDate=${startDate.toIso8601String()}&EndDate=${endDate.toIso8601String()}&ForMe=false',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final taskDataList = responseData['data'] as List<dynamic>;
      final tasks = taskDataList
          .expand((item) => (item['tasks'] as List<dynamic>))
          .map((json) => Task.fromJson(json))
          .toList();

      return tasks;
    } else {
      print('Failed to load tasks: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load tasks');
    }
  }
}
