import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/config/constants/colors.dart';
import 'package:hocflutter/screens/bottomSheet/task_bottomsheet.dart';

import 'package:hocflutter/screens/login_screen.dart';
import 'package:hocflutter/screens/task_detail_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
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

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat dateFormatD = DateFormat('yyyy-MM-dd');
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
    print('Fetching tasks...');
    try {
      if (widget.accessToken.isNotEmpty &&
          _startDate != null &&
          _endDate != null) {
        tasks = await _apiService.fetchTasks(
            widget.accessToken, _startDate!, _endDate!);
        setState(() {});
      } else {
        print('Access token, start date, or end date is missing.');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
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

  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    await _authService.signOut();
    context.go('/login', extra: {'replace': true});
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
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Column(
            children: [
              // _buidlSearch(),
              // SizedBox(height: 16),
              _buildTable(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text(
                "Tasks on ${_startDate != null ? dateFormatD.format(_startDate!) : 'Unknown Date'} - ${_endDate != null ? dateFormatD.format(_endDate!) : 'Unknown Date'}",
                style: TextStyle(
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Container(
                            width: screenWidth * 0.7,
                            child: Text(
                              task.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.arrow_drop_down, size: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                _buidlFreetime()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return TableCalendar(
      headerStyle: HeaderStyle(
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
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
        cellMargin: EdgeInsets.all(6.0),
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
