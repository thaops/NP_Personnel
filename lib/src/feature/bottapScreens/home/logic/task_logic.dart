import 'package:flutter/material.dart';
import 'package:hocflutter/src/Api/models/task_model.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';

class TaskLogic with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task>? tasks;
  DateTime? starDate;
  DateTime? endDate;
  bool isSwitched = false;

  Future<void> fetchTasks(
      String accessToken,
      DateTime startDate,
      DateTime endDate,
      String project,
      bool isSwitched,
      BuildContext context) async {
    try {
      if (accessToken.isNotEmpty && startDate != null && endDate != null) {
        project ??= '';
        tasks = await _apiService.fetchTasks(
            accessToken, startDate!, endDate!, project!, isSwitched, context);
        notifyListeners();
      } else {
        print('Access token, start date, or end date is missing.');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      tasks = [];
      notifyListeners();
    }
  }

  void updateTaskFilter(
      bool isSwitched, DateTime? startDate, DateTime? endDate) {
    this.isSwitched = isSwitched;
    this.starDate = startDate;
    this.endDate = endDate;
    notifyListeners();
  }
}
