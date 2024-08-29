import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/config/constants/colors.dart';
import 'package:hocflutter/config/router/router.dart';
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
  ApiService apiService = ApiService();
  late TextEditingController _controller;
  late TextEditingController _controllerNote;
  late DateTime _startDate;
  late DateTime _dueDate;
  late String _status;
  late String _priority;
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
    'state': _status ,
    'priority': _priority,
    'projectId': '09764aab-bfe7-4602-b416-0a9057ceda5d', 
    'sprintId': 'd142acbc-bbe0-4963-82de-1d4f13319953', 
    'parentTaskId': null,
    'assigneeId': '14cc6fd9-797e-4190-ac27-bd927d7b4858' 
  };

  print("add Data: $addData");

  final response = await apiService.addTask(accessToken, addData);

  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.message}");
  print("state : $_status");
  print("priority : $_priority");

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
              TaskInfoRow(
                label1: "Nhân Viên",
                value1: 'Phạm Đồng Thảo',
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
                    minimumSize:
                        Size(screenWidth, 48), // Độ rộng và chiều cao của nút
                    backgroundColor: dark_blue, // Màu nền của nút
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Bo tròn góc
                    ),
                    elevation: 4, // Độ nổi của nút
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
