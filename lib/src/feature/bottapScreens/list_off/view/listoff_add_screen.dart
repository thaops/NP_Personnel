import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/src/Api/models/users_model.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/models/leave.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/widget/listoff_leave.dart';
import 'package:hocflutter/widgets/menu/task_info_row.dart';
import 'package:hocflutter/widgets/tasks/task_date_row.dart';
import 'package:hocflutter/widgets/tasks/task_note_section.dart';
import 'package:provider/provider.dart';

class ListoffAddScreen extends StatefulWidget {
  const ListoffAddScreen({super.key});

  @override
  State<ListoffAddScreen> createState() => _ListoffAddScreenState();
}

class _ListoffAddScreenState extends State<ListoffAddScreen> {
  List<UserModel>? users;
  List<LeaveType>? leaves;
  String? usersID;
  String? leaveID;
  late DateTime _startDate;
  late DateTime _dueDate;
  late TextEditingController _controllerNote;
  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _dueDate = DateTime.now().add(Duration(days: 1));
    _controllerNote = TextEditingController();
    fetchUsers();
    fetchLeave();
  }

  void _save() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    Map<String, dynamic> addData = {
      'reason': _controllerNote.text,
      'fromDate': _startDate.toIso8601String(),
      'toDate': _dueDate.toIso8601String(),
      'categoryId': leaveID,
      'employeeId': usersID,
    };

    final response = await apiService.addLeave(accessToken, addData, context);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo  Task Thành công')),
      );
      Navigator.pop(context, true);
    } else {
      print("addData$addData");
      print(response);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo Task Thất bại: ${response.message}')),
      );
    }
  }

  Future<void> fetchUsers() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await apiService.getUsers(accessToken, context);
        if (response != null) {
          setState(() {
            users = response;
          });
        } else {
          print('No user data found.');
        }
      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> fetchLeave() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await apiService.getLeave(accessToken, context);
        if (response != null) {
          setState(() {
            leaves = response;
          });
        } else {
          print('No user data found.');
        }
      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _updateDate(DateTime newDate, bool isStartDate) {
    setState(() {
      if (isStartDate) {
        _startDate = newDate;
      } else {
        _dueDate = newDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo đơn xin nghỉ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: dark_blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TaskInfoRow(
                      label1: "Họ và tên ",
                      usersList: users,
                      onProjectSelected: (selectedUser) {
                        setState(() {
                          usersID = selectedUser?.id;
                        });
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListoffLeave(
                      label1: "Lý do ",
                      leaveList: leaves,
                      onProjectSelected: (selectedUser) {
                        setState(() {
                          leaveID = selectedUser?.id;
                        });
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TaskDateRow(
                      label1: "Nghỉ từ ngày",
                      date1: _startDate,
                      label2: "Đến ngày",
                      date2: _dueDate,
                      onDateSelected: _updateDate,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TaskNoteSection(
                      label: 'Ghi chú:',
                      note: '',
                      screenWidth: screenWidth,
                      controllerNote: _controllerNote,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(Icons.save),
                  label: Text('Tạo Đơn'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth, 48),
                    backgroundColor: dark_blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
