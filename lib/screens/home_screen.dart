import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/screens/login_screen.dart';
import 'package:hocflutter/screens/task_detail_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
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

  @override
  void TimeDay() {
    print("DateTime_startDate"+_startDate.toString().split(" ")[0]);
    print("DateTime_endDate"+_endDate.toString().split(" ")[0]);
  }
  Set<DateTime> selectedDays = {};
  List<Task>? tasks;
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
    TimeDay();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 44,
                    width: 44,
                  ),
                  Container(
                    width: screenWidth * 0.6,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(child: Text("Configuration", style: TextStyle(fontSize: 14),)),
                        Container(child: Text("Statistic", style: TextStyle(fontSize: 14),)),
                        Container(child: Text("Kanban", style: TextStyle(fontSize: 14),)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, size: 20),
                    onPressed: _signOut,
                  ),
                ],
              ),
              SizedBox(height: 14,),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'search..........',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TableCalendar(
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  titleTextStyle: TextStyle(fontSize: 0),
                  rightChevronVisible: false,
                  leftChevronVisible: false,
                ),
                availableGestures: AvailableGestures.all,
                rowHeight: 80,
                selectedDayPredicate: (day) {
                  return isSameDay(day, _startDate) || isSameDay(day, _endDate);
                },
                focusedDay: today,
                firstDay: DateTime.utc(2010, 08, 08),
                lastDay: DateTime.utc(2025, 12, 12),
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  outsideDecoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                  defaultDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: Colors.blueGrey,
                ),
                rangeStartDay: _startDate,
                rangeEndDay: _endDate,
              ),
              Container(height: 1, color: Colors.black,),
              SizedBox(height: 20,),
              Text("Task Ngày: "+today.toString().split(" ")[0], style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 16),),
              if (tasks != null && tasks!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tasks!.length,
                  itemBuilder: (context, index) {
                    final task = tasks![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          task.state,
                                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                        ),
                                        Icon(Icons.arrow_drop_down, size: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                      Text('No tasks available', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.teal),),
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
