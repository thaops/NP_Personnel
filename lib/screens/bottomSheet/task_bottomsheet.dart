// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/tasks/text_tasks.dart';

class TaskBottomsheet extends StatefulWidget {
  final Task task;
  final Function(bool) onUpdateCallback;
  const TaskBottomsheet({
    Key? key,
    required this.task,
    required this.onUpdateCallback,
  }) : super(key: key);

  @override
  State<TaskBottomsheet> createState() => _TaskBottomsheetState();
}

class _TaskBottomsheetState extends State<TaskBottomsheet> {
  Task? _fetchedTask;

  @override
  void initState() {
    super.initState();
    _getTask();
  }

  void _getTask() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final taskId = widget.task.id;

    print("taskId: $taskId");

    final Task? fetchedTask = await apiService.getTask(taskId, accessToken,context);

    if (fetchedTask != null) {
      setState(() {
        _fetchedTask = fetchedTask;
      });
      print('Fetched Task: ${fetchedTask.toString()}');
    } else {
      print('Failed to fetch task');
    }
  }

  void _update() {
    GoRouter.of(context)
        .push('/details/tasks', extra: _fetchedTask)
        .then((value) {
      if (value == true) {
        widget.onUpdateCallback(true);
        _getTask();
      }
    });
  }

  void _delete() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;
    final taskId = widget.task.id;

    // Hiển thị hộp thoại xác nhận trước khi xóa
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn muốn xóa task này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final bool success = await apiService.deleteTask(taskId, accessToken,context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa task thành công')),
        );
        widget.onUpdateCallback(true);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa task thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final DateFormat dateFormatD = DateFormat('HH:mm yyyy-MM-dd');

    return Container(
      width: screenWidth,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.6,
                    child: Text(
                      _fetchedTask?.title ?? widget.task.title,
                      style: GogbalStyles.heading2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _update();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _delete();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTasks(
                      text1: 'Dự án',
                      text2: _fetchedTask?.project ?? widget.task.project,
                    ),
                    SizedBox(height: 20),
                    TextTasks(
                      text1: 'Nhân viên',
                      text2: _fetchedTask?.creator ?? widget.task.creator,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextTasks(
                                text1: 'Độ ưu tiên',
                                text2: _fetchedTask?.priority ??
                                    widget.task.priority,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextTasks(
                                text1: 'Trạng thái',
                                text2: _fetchedTask?.state ?? widget.task.state,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextTasks(
                              text1: 'Ngày bắt đầu',
                              text2: dateFormatD.format(_fetchedTask?.startDate ??
                                  widget.task.startDate),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextTasks(
                                text1: 'Ngày kết thúc',
                                text2: dateFormatD.format(
                                    _fetchedTask?.dueDate ?? widget.task.dueDate),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextTasks(
                      text1: 'Chú thích',
                      text2: _fetchedTask?.note ?? widget.task.note,
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
