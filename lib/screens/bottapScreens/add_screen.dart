import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';
import 'package:hocflutter/Api/models/Users.dart';
import 'package:hocflutter/Api/models/sprint_model.dart';
import 'package:hocflutter/config/constants/colors.dart';
import 'package:hocflutter/config/router/router.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/home/custom_switch.dart';
import 'package:hocflutter/widgets/menu/project_dropdown.dart';
import 'package:hocflutter/widgets/menu/task_sprint_row.dart';
import 'package:hocflutter/widgets/task_date_row.dart';
import 'package:hocflutter/widgets/task_info_row.dart';
import 'package:hocflutter/widgets/task_note_section.dart';
import 'package:hocflutter/widgets/task_status_priority_row.dart';
import 'package:hocflutter/widgets/task_title_section.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final ApiService _apiService = ApiService();
  late TextEditingController _controller;
  late TextEditingController _controllerNote;
  late DateTime _startDate;
  late DateTime _dueDate;
  late String _status;
  late String _priority;
  List<UserModel>? users;
  String? usersID;
  List<Project>? projectList;
  String? project;
  List<Sprint>? sprints;
  String? sprintID;
  bool _isWbs = false;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controllerNote = TextEditingController();
    _startDate = DateTime.now();
    _dueDate = DateTime.now().add(Duration(days: 1));
    _status = 'backlog';
    _priority = 'low';
    fetchUsers();
    _fetchProject();
    fetchSprint();
  }

  Future<void> _fetchProject() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    try {
      if (accessToken.isNotEmpty) {
        final response = await _apiService.getProject(accessToken);
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

  Future<void> fetchSprint() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await _apiService.getSprint(
            accessToken, project ?? '09764aab-bfe7-4602-b416-0a9057ceda5d');
        if (response != null) {
          setState(() {
            sprints = response;
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

  Future<void> fetchUsers() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await _apiService.getUsers(
          accessToken,
        );
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

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  void _updatePriority(String newPriority) {
    setState(() {
      _priority = newPriority;
    });
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

  void _saveTask() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    Map<String, dynamic> addData = {
      'title': _controller.text,
      'note': _controllerNote.text,
      'startDate': _startDate.toIso8601String(),
      'dueDate': _dueDate.toIso8601String(),
      'state': _status,
      'priority': _priority,
      'projectId': project,
      'sprintId': sprintID,
      'parentTaskId': null,
      'assigneeId': usersID,
      "wbs": _isWbs
    };

    final response = await apiService.addTask(accessToken, addData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo  Task Thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo Task Thất bại: ${response.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 4,
        backgroundColor: dark_blue,
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        ),
        actions: [
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              TaskTitleSection(
                label: 'Tiêu đề công việc:',
                title: '',
                screenWidth: screenWidth,
                controller: _controller,
              ),
              const SizedBox(height: 24),
              const Text(
                "Project",
                style: GogbalStyles.heading3,
              ),
              const SizedBox(height: 8),
              ProjectDropdown(
                projectList: projectList,
                onProjectSelected: (selectedProject) {
                  setState(() {
                    project = selectedProject?.id;
                  });
                },
              ),
              SizedBox(height: 16),
              TaskSprintRow(
                label1: "Sprint",
                sprintsList: sprints,
                onProjectSelected: (selectedSprint) {
                  setState(() {
                    sprintID = selectedSprint?.id;
                  });
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text(
                          _isWbs ? "WBS" : "Task",
                          style: GogbalStyles.heading3,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    CustomSwitch(
                      value: _isWbs,
                      onChanged: (value) {
                        setState(() {
                          _isWbs = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TaskInfoRow(
                label1: "Nhân Viên",
                usersList: users,
                onProjectSelected: (selectedUser) {
                  setState(() {
                    usersID = selectedUser?.id;
                  });
                },
              ),
              const SizedBox(height: 16),
              TaskStatusPriorityRow(
                label1: "Trạng Thái",
                value1: _status,
                onStatusSelected: _updateStatus,
                label2: "Độ ưu tiên",
                value2: _priority,
                onPrioritySelected: _updatePriority,
              ),
              const SizedBox(height: 16),
              TaskDateRow(
                label1: "Ngày bắt đầu",
                date1: _startDate,
                label2: "Ngày đến hạn",
                date2: _dueDate,
                onDateSelected: _updateDate,
              ),
              const SizedBox(height: 16),
              TaskNoteSection(
                label: 'Note:',
                note: '',
                screenWidth: screenWidth,
                controllerNote: _controllerNote,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveTask,
                  icon: Icon(Icons.save),
                  label: Text('Lưu'),
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
              const SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }
}
