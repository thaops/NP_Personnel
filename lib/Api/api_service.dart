import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/ApiResponse.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';
import 'package:hocflutter/Api/models/Users.dart';
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
    final String url = '$_baseUrl/tasks/$taskId';
    print("url : $url");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

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

  Future<Task?> getTask(String taskId, String accessToken) async {
    final String url = '$_baseUrl/tasks/$taskId';
    print("url : $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final Map<String, dynamic> taskJson = jsonResponse['data'];
        return Task.fromJson(taskJson);
      } else {
        print('Failed to load task');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> deleteTask(String taskId, String accessToken) async {
    final String url = '$_baseUrl/tasks/$taskId';
    print("url : $url");

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully');
        return true;
      } else {
        print('Failed to delete task');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<taskResponse> addTask(
      String accessToken, Map<String, dynamic> addData) async {
    final String url = '$_baseUrl/tasks';
    print("url : $url");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(addData),
      );

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
      print("ApiResponse ${ApiResponse.fromJson(json.decode(response.body))}");
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

  Future<List<Task>> fetchTasks(String accessToken, DateTime startDate,
      DateTime endDate, String project, bool _isSwitched) async {
    final url = Uri.parse(
      '$_baseUrl/tasks?project=$project&page=1&pageSize=50&StartDate=${startDate.toIso8601String()}&EndDate=${endDate.toIso8601String()}&ForMe=$_isSwitched',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("response: $url");
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

  Future<List<Project>?> getProject(String accessToken) async {
    final String url = '$_baseUrl/projects?page=1&pageSize=9999';
    print("response: $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> projectsJson = jsonResponse['data'];
        List<Project> projects = projectsJson
            .map((projectJson) => Project.fromJson(projectJson))
            .toList();
        return projects;
      } else {
        print('Failed to load task');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<User>?> getUsers(String accessToken) async {
    final String url = '$_baseUrl/users?page=1&pageSize=9999';
    print("Request URL: $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> usersJson = jsonResponse['data'];
         print("jsonResponse $usersJson");
        List<User> users =
            usersJson.map((userJson) => User.fromJson(userJson)).toList();
        return users;
      } else {
        print('Failed to load users');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
