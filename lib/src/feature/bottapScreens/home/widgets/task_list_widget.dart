// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hocflutter/src/Api/models/task_model.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottomSheet/task/task_bottomsheet.dart';

class TaskListWidget extends StatefulWidget {
  final List<Task>? tasksList;
  final Function(bool update) updateTaskList;
  const TaskListWidget({
    Key? key,
    this.tasksList,
    required this.updateTaskList,
  }) : super(key: key);

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  
  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.tasksList!.length,
      itemBuilder: (context, index) {
        final task = widget.tasksList![index];
        Color titleColor;
        switch (task.state) {
          case 'In progress':
            titleColor = in_progress;
            break;
          case 'Backlog':
            titleColor = backlog;
            break;
          case 'Done':
            titleColor = done;
            break;
          case 'Pending':
            titleColor = pending;
            break;
          default:
            titleColor = Colors.black;
        }

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => TaskBottomsheet(
                task: task,
                onUpdateCallback: widget.updateTaskList,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: SizedBox(
                width: screenWidth * 0.7,
                child: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                        color: titleColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.arrow_drop_down, size: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
