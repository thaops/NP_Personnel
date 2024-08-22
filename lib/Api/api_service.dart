import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/ApiResponse.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/Api/models/taskResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends ChangeNotifier {
  final String _baseUrl = 'https://napro-api.azurewebsites.net/api';

  String _accessTokenId = '';
  String get accessTokenId => _accessTokenId;
  void setAccessTokenId(String token) {
    _accessTokenId = token;
    notifyListeners();
  }

  bool isLoading = true;
  String err = '';
  Future<taskResponse> updateTask(String taskId, String accessToken,
      Map<String, dynamic> updateData) async {
    final String url = '$_baseUrl/tasks/?id=$taskId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );
      // In ra chi tiết thông tin phản hồi
      print("Response Status: ${response.statusCode}");
      print("Response Body api: ${response.body}");
      

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return taskResponse.fromJson(data);
      } else {
        return taskResponse(
          statusCode: response.statusCode,
          message: 'Request failed with status: ${response.statusCode}',
          totalRecord: 0,
          data: '',
        );
      }
    } catch (e) {
      return taskResponse(
        statusCode: 500,
        message: 'An error occurred: $e',
        totalRecord: 0,
        data: '',
      );
    }
  }

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
