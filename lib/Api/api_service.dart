import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/apiResponse.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';
import 'package:hocflutter/Api/models/employee.dart';
import 'package:hocflutter/Api/models/users.dart';
import 'package:hocflutter/Api/models/profileModel.dart';
import 'package:hocflutter/Api/models/sprint_model.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/Api/models/taskResponse.dart';
import 'package:hocflutter/config/constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ApiService extends ChangeNotifier {

  bool _isVision = true;

  bool get isVision => _isVision;

  void setIsVision(bool vision) {
    _isVision = vision;
     print('isVision updated: $_isVision');
    notifyListeners(); 
  }

  String? _projectId;
  String? get projectId => _projectId;
  void setProjectId(project) {
    _projectId = project;
    notifyListeners();
  }

  String _accessTokenId = '';
  String get accessTokenId => _accessTokenId;
  void setAccessTokenId(String token) {
    _accessTokenId = token;
    notifyListeners();
  }
  String getBaseUrl(BuildContext context) {
    return BaseUrlProvider.getBaseUrl(context);
  }


  Future<taskResponse> updateTask(String taskId, String accessToken,
      Map<String, dynamic> updateData,BuildContext context) async {
        
    final String url = '${getBaseUrl(context)}/tasks/$taskId';
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

  Future<Task?> getTask(String taskId, String accessToken,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/tasks/$taskId';

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

  Future<bool> deleteTask(String taskId, String accessToken,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/tasks/$taskId';

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
      String accessToken, Map<String, dynamic> addData,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/tasks';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(addData),
      );

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

  Future<ApiResponse> sendTokenToApi(String token,BuildContext context) async {
    final response = await http.post(
      Uri.parse('${getBaseUrl(context)}/users/oauth2-google'),
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

  Future<List<Task>> fetchTasks(String accessToken, DateTime startDate,
      DateTime endDate, String project, bool _isSwitched,BuildContext context) async {
    final url = Uri.parse(
      '${getBaseUrl(context)}/tasks?project=$project&page=1&pageSize=50&StartDate=${startDate.toIso8601String()}&EndDate=${endDate.toIso8601String()}&ForMe=$_isSwitched',
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

  Future<List<Project>?> getProject(String accessToken,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/projects?page=1&pageSize=9999';
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

  Future<List<UserModel>?> getUsers(String accessToken,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/users?page=1&pageSize=9999';
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
        List<UserModel> users =
            usersJson.map((userJson) => UserModel.fromJson(userJson)).toList();
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

  Future<List<Sprint>?> getSprint(String accessToken, String project,BuildContext context) async {
    final String url =
        '${getBaseUrl(context)}/sprints?project=$project&page=1&pageSize=9999&startDate=2023-12-04&endDate=2222-12-31';
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
        final List<dynamic> sprintsJson = jsonResponse['data'];
        List<Sprint> sprints = sprintsJson
            .map((sprintJson) => Sprint.fromJson(sprintJson))
            .toList();
        return sprints;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Profile?> getProfile(String accessToken,BuildContext context) async {
    final String url = '${getBaseUrl(context)}/users/profile';
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
        return Profile.fromJson(taskJson);
      } else {
        print('Failed to load task');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Employee>?> getListOff(String accessToken,DateTime firstDayOfMonth,DateTime lastDayOfMonth, context) async {
    final String url =
        '${getBaseUrl(context)}/dayoff/list-day-off?pageIndex=1&pageSize=9999&fromDate=$firstDayOfMonth&toDate=$lastDayOfMonth&keyword=';
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
        final List<dynamic> employeeJson = jsonResponse['data'];
        List<Employee> employee = employeeJson
            .map((employeeJson) => Employee.fromJson(employeeJson))
            .toList();
        return employee;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
