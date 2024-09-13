import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/config/constants/colors.dart';
import 'package:hocflutter/screens/bottomSheet/task_bottomsheet.dart';

import 'package:hocflutter/screens/login_screen.dart';
import 'package:hocflutter/screens/task_detail_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/home/custom_switch.dart';
import 'package:hocflutter/widgets/menu/project_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  HomeScreen({required this.accessToken});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
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

  final AuthService _authService = AuthService();

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

  @override
  void initState() {
    super.initState();
    _fetchProject();
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
    // await _fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      const SizedBox(
                        width: 10,
                      ),
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
                _buildTable(),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Text(
                  "Tasks on ${_startDate != null ? dateFormatD.format(_startDate!) : 'Unknown Date'} - ${_endDate != null ? dateFormatD.format(_endDate!) : 'Unknown Date'}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (tasks != null && tasks!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tasks!.length,
                    itemBuilder: (context, index) {
                      final task = tasks![index];
                      Color titleColor;
                      switch (task.state) {
                        case 'In progress':
                          titleColor = in_progress;
                          break;
                        case 'Backlog':
                          titleColor = backlog;
                          break;
                        case 'Done':
                          titleColor = done;
                          break;
                        case 'Pending':
                          titleColor = pending;
                          break;
                        default:
                          titleColor = Colors.black;
                      }

                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => TaskBottomsheet(
                              task: task,
                              onUpdateCallback: _updateTaskList,
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: SizedBox(
                              width: screenWidth * 0.7,
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  task.state,
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.bold),
                                      
                                ),
                                SizedBox(width: 10,),
                                const Icon(Icons.arrow_drop_down, size: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  _buidlFreetime(),
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

  Widget _buildTable() {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerMargin: EdgeInsets.only(bottom: 16),
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
        ),
        availableGestures: AvailableGestures.all,
        rowHeight: 60,
        selectedDayPredicate: (day) {
          return isSameDay(day, _startDate) || isSameDay(day, _endDate);
        },
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010, 08, 08),
        lastDay: DateTime.utc(2025, 12, 12),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(6.0),
          outsideDaysVisible: false,
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          outsideDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          todayDecoration: BoxDecoration(
            color: Colors.indigo.shade200,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: dark_blue, width: 1.0),
          ),
          selectedDecoration: BoxDecoration(
            color: dark_blue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue.shade300, width: 1.0),
          ),
          rangeHighlightColor: Colors.blue.shade100.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buidlSearch() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.search,
              size: 24,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidlFreetime() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Image.asset(
            'assets/solutions.png',
            height: 150,
            width: 300,
          ),
        ],
      ),
    );
  }
}
