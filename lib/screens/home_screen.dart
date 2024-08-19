import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/task.dart';
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

  Set<DateTime> selectedDays = {};
  List<Task>? tasks;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
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
      if (widget.accessToken.isNotEmpty && _startDate != null && _endDate != null) {
        tasks = await _apiService.fetchTasks(widget.accessToken, _startDate!, _endDate!);
        setState(() {});
      } else {
        print('Access token, start date, or end date is missing.');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_startDate == null) {
      setState(() {
        _startDate = selectedDay;
        _endDate = null;
      });
    } else if (_endDate == null && selectedDay.isAfter(_startDate!)) {
      setState(() {
        _endDate = selectedDay;
      });
    } else {
      setState(() {
        _startDate = selectedDay;
        _endDate = null;
      });
    }
    _checkAndFetchTasks();
  }

  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    await _authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
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
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Container(
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
              ),
              SizedBox(height: 16),
              TableCalendar(
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
                rowHeight: 65,
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
                    borderRadius: BorderRadius.circular(8.0), // Bo góc mềm mại
                    border: Border.all(color: Colors.grey.shade300, width: 1.0), // Đường viền mỏng
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
                    color: Colors.teal.shade50,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.teal.shade200, width: 1.0),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.teal.shade700, width: 1.0),
                  ),
                  rangeHighlightColor: Colors.teal.shade100.withOpacity(0.5),
                ),
              ),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text(
                "Tasks on ${_startDate != null ? dateFormat.format(_startDate!) : 'Unknown Date'} - ${_endDate != null ? dateFormat.format(_endDate!) : 'Unknown Date'}",
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) => TaskDetailScreen(task: task),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            task.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                task.state,
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        'No tasks available',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      SizedBox(height: 16),
                      Image.asset(
                        'assets/notdata.png',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
