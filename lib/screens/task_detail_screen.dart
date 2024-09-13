import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/users.dart';
import 'package:hocflutter/Api/models/sprint_model.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/config/constants/colors.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/home/custom_switch.dart';
import 'package:hocflutter/widgets/menu/task_sprint_row.dart';
import 'package:hocflutter/widgets/task_title_section.dart';
import 'package:hocflutter/widgets/task_info_row.dart';
import 'package:hocflutter/widgets/task_status_priority_row.dart';
import 'package:hocflutter/widgets/task_date_row.dart';
import 'package:hocflutter/widgets/task_note_section.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  ApiService apiService = ApiService();
  late TextEditingController _controller;
  late TextEditingController _controllerNote;
  late DateTime _startDate;
  late DateTime _dueDate;
  late String _status;
  late String _priority;
  late String _sprintTitle;
  late String _sprintId;
  late String _creatorId;
  late String _project;
  late String _creator;
  List<UserModel>? users;
  String? usersID;
  bool _isWbs = false;
  List<Sprint>? sprints;
  String? sprintID;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
    _controllerNote = TextEditingController(text: widget.task.note);
    _startDate = widget.task.startDate;
    _dueDate = widget.task.dueDate;
    _status = widget.task.state;
    _priority = widget.task.priority;
    _sprintId = widget.task.sprintId;
    _project = widget.task.project;
    _creatorId = widget.task.creatorId;
    _sprintTitle = widget.task.sprintTitle;
    _creator = widget.task.creator;
    fetchUsers();
    fetchSprint();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNote.dispose();
    super.dispose();
  }

  Future<void> fetchSprint() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final projectId = apiService.projectId;
    print("projectId: $projectId");
    try {
      if (accessToken.isNotEmpty) {
        final response = await apiService.getSprint(
            accessToken, projectId ?? '09764aab-bfe7-4602-b416-0a9057ceda5d',context);
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

  void _updateDate(DateTime newDate, bool isStartDate) {
    setState(() {
      if (isStartDate) {
        _startDate = newDate;
      } else {
        _dueDate = newDate;
      }
    });
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus.toLowerCase();
    });
  }

  void _updatePriority(String newPriority) {
    setState(() {
      _priority = newPriority.toLowerCase();
    });
  }

  Future<void> fetchUsers() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await apiService.getUsers(
          accessToken,context
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

  void _saveTask() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final taskId = widget.task.id;

    Map<String, dynamic> updateData = {
      'title': _controller.text,
      'note': _controllerNote.text,
      'startDate': _startDate.toIso8601String(),
      'dueDate': _dueDate.toIso8601String(),
      'state': _status.toLowerCase(),
      'priority': _priority.toLowerCase(),
      'assigneeId': usersID ?? _creatorId,
      "wbs": _isWbs,
      'sprintId': sprintID ?? _sprintId,
    };

    final response =
        await apiService.updateTask(taskId, accessToken, updateData,context);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật Task Thành công')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật Task Thất bại: ${response.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskId = widget.task.id;

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Update',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 4,
        backgroundColor: dark_blue,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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
                title: widget.task.title,
                screenWidth: screenWidth,
                controller: _controller,
              ),
              const SizedBox(height: 24),
              TaskSprintRow(
                label1: "Sprint",
                nameSprint: _sprintTitle,
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
                name: _creator,
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
                value1: _status.toLowerCase(),
                onStatusSelected: (status) => _updateStatus(status),
                label2: "Độ ưu tiên",
                value2: _priority.toLowerCase(),
                onPrioritySelected: (priority) => _updatePriority(priority),
              ),
              const SizedBox(height: 16),
              TaskDateRow(
                label1: "Ngày bắt đầu",
                date1: _startDate,
                label2: "Ngày đến hạn",
                date2: _dueDate,
                onDateSelected: (newDate, isStartDate) {
                  _updateDate(newDate, isStartDate);
                },
              ),
              const SizedBox(height: 16),
              TaskNoteSection(
                label: 'Note:',
                note: widget.task.note,
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
            ],
          ),
        ),
      ),
    );
  }
}
