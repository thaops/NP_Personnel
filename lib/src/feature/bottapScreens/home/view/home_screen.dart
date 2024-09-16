import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:hocflutter/src/Api/models/project_model.dart';
import 'package:hocflutter/src/Api/models/task_model.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/logic/task_logic.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/widgets/home_calendar_widget.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/widgets/home_freetime_wiget.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/widgets/home_menu_widget.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/widgets/home_task_list_widget.dart';

import 'package:hocflutter/src/feature/bottomSheet/task/task_bottomsheet.dart';

import 'package:hocflutter/src/feature/login/login_screen.dart';
import 'package:hocflutter/src/feature/update_task/task_update_screen.dart';
import 'package:hocflutter/src/services/lib/services/auth_service.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/home/custom_switch.dart';
import 'package:hocflutter/widgets/menu/project_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  HomeScreen({required this.accessToken});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProject();

  }

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  DateTime today = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();

  List<DateTime> selectedDays = [];
  List<Task>? tasks;
  List<Project>? projectList;
  String? project;

  bool _isSwitched = false;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss.SSS');
  final DateFormat dateFormatD = DateFormat('dd-MM-yyyy');

  void _checkAndFetchTasks() {
    if (_startDate != null && _endDate != null) {
      _fetchTasks();
    } else {
      setState(() {
        tasks = null;
      });
    }
  }

  Future<void> _fetchTasks() async {
    try {
      if (widget.accessToken.isNotEmpty &&
          _startDate != null &&
          _endDate != null) {
        project ??= '';
          tasks = await _apiService.fetchTasks(widget.accessToken, _startDate!,
            _endDate!, project!, _isSwitched, context);
        setState(() {});
      } else {
        print('Access token, start date, or end date is missing.');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      setState(() {
        tasks = [];
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_startDate == null) {
        _startDate = selectedDay;
        selectedDays.clear();
        selectedDays.add(selectedDay);
      } else if (selectedDays.contains(selectedDay)) {
        selectedDays.remove(selectedDay);
      } else {
        if (selectedDays.length >= 2) {
          selectedDays.clear();
        }
        selectedDays.add(selectedDay);
      }
      selectedDays.sort((a, b) => a.compareTo(b));

      if (selectedDays.isNotEmpty) {
        _startDate = DateTime(selectedDays.first.year, selectedDays.first.month,
            selectedDays.first.day, 0, 0, 0);
        _endDate = DateTime(selectedDays.last.year, selectedDays.last.month,
            selectedDays.last.day, 23, 59, 59);
      } else {
        _startDate = null;
        _endDate = null;
      }
    });

    _checkAndFetchTasks();
  }

  void _updateTaskList(bool update) {
    if (update) {
      _fetchTasks();
    }
  }

  Future<void> _refreshProjects() async {
    await _fetchTasks();
  }

  Future<void> _signOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Ngăn người dùng đóng hộp thoại bằng cách nhấn ngoài nó
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Đóng hộp thoại và trả về false
              },
            ),
            TextButton(
              child: Text('Đăng xuất'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Đóng hộp thoại và trả về true
              },
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true) {
      await _authService.signOut();
      context.go('/login', extra: {'replace': true});
    }
  }

  Future<void> _fetchProject() async {
    try {
      if (widget.accessToken.isNotEmpty) {
        final response =
            await _apiService.getProject(widget.accessToken, context);
        if (response != null) {
          setState(() {
            projectList = response;
          });
        } else {
          print('No project data found.');
        }
      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  Future<void> refresh() async {
    await _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MenuWidget(),
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            _isSwitched ? "Cá nhân" : "Mọi Người",
                            style: GogbalStyles.heading3,
                          )),
                      const SizedBox(height: 10),
                      CustomSwitch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                          _fetchTasks();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ProjectDropdown(
                  projectList: projectList,
                  onProjectSelected: (selectedProject) {
                    setState(() {
                      project = selectedProject?.id;
                      _apiService.setProjectId(selectedProject?.id);
                    });
                    _fetchTasks();
                  },
                  onRefresh: _refreshProjects,
                ),
                const SizedBox(height: 16),
                HomeCalendarWidget(
                  startDate: _startDate ?? DateTime.now(),
                  endDate: _endDate ?? DateTime.now(),
                  onDaySelected: _onDaySelected,
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Text(
                    "Tasks on ${_startDate != null ? dateFormatD.format(_startDate!) : 'Unknown Date'} - ${_endDate != null ? dateFormatD.format(_endDate!) : 'Unknown Date'}",
                    style: GogbalStyles.bodyTextbold),
                tasks != null && tasks!.isNotEmpty
                    ? HomeTaskListWidget(
                        updateTaskList: _updateTaskList,
                        tasksList: tasks,
                      )
                    : HomeFreetimeWiget(),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
