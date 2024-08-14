import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/screens/login_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _accessToken = 'Loading...'; // Hiển thị thông báo tải dữ liệu
  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchAccessToken();
  }

  Future<void> _fetchAccessToken() async {
    try {
      final authService = AuthService();
      final accessToken = await authService.getAccessToken();
      if (accessToken != null) {
        final response = await _apiService.sendTokenToApi(accessToken);
        print('API Response: ${response.message}');
      }
      setState(() {
        _accessToken = accessToken ?? 'No token found';
        print('Access Token User: $_accessToken');
      });
    } catch (e) {
      setState(() {
        _accessToken = 'Failed to fetch token';
      });
      print('Error fetching access token: $e');
    }
  }


  DateTime today = DateTime.now();
  Set<DateTime> selectedDays = {};
  String selectedValue = "Chọn trạng thái";

  void _onSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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
      body: SingleChildScrollView(  // Thêm SingleChildScrollView ở đây
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
                height: 40,
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
              SizedBox(height: 40,),
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
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 08, 08),
                lastDay: DateTime.utc(2025, 12, 12),
                onDaySelected: _onSelected,
              ),
              Container(height: 1, color: Colors.black,),
              SizedBox(height: 20,),
              Text(today.toString().split(" ")[0], style: TextStyle(color: Colors.cyan),),
              SizedBox(height: 10,),
              Container(
                height: 60,
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
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Hoàn thành', 'Đang làm', 'Đã hoàn thành'}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                        child: Container(
                          width: screenWidth * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tiêu đề",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text(selectedValue),
                                    Icon(Icons.arrow_drop_down, size: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
