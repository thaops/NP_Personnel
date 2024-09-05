import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/config/constants/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
    _controllerNote = TextEditingController(text: widget.task.note);
    _startDate = widget.task.startDate;
    _dueDate = widget.task.dueDate;
    _status = widget.task.state;
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNote.dispose();
    super.dispose();
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

  void _saveTask() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final taskId = widget.task.id;

    Map<String, dynamic> updateData = {
      'title': _controller.text,
      'note': _controllerNote.text,
      'startDate': _startDate.toIso8601String(),
      'dueDate': _dueDate.toIso8601String(),
      'state': _status,
      'priority': _priority,
    };

    print("Update Data: $updateData");

    final response =
        await apiService.updateTask(taskId, accessToken, updateData);
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
    print("taskId: $taskId");
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
                title: widget.task.title,
                screenWidth: screenWidth,
                controller: _controller,
              ),
              const SizedBox(height: 24),
              TaskInfoRow(
                label1: "Nhân Viên",
                
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
