// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hocflutter/src/Api/models/task_model.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottomSheet/task/task_bottomsheet.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:intl/intl.dart';

class HomeTaskListWidget extends StatefulWidget {
  final List<Task>? tasksList;
  final Function(bool update) updateTaskList;
  const HomeTaskListWidget({
    Key? key,
    this.tasksList,
    required this.updateTaskList,
  }) : super(key: key);

  @override
  State<HomeTaskListWidget> createState() => _HomeTaskListWidgetState();
}

class _HomeTaskListWidgetState extends State<HomeTaskListWidget> {
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
         child:  _buildTaskItem(task)
        );
      },
    );
  }
}

Widget _buildTaskItem(Task task) {
  final DateFormat dateFormat = DateFormat("dd-MM");
  String avatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
  final titleColor = _getStatusColor(task.state);
  return GestureDetector(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    avatar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? 'Không lý do',
                      style: GogbalStyles.bodyText2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${dateFormat.format(task.startDate)} - ${dateFormat.format(task.dueDate)}',
                      style: GogbalStyles.bodyText3,
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  task.state ?? 'Chưa có thông tin',
                  style: TextStyle(color: titleColor),
                ),
                SizedBox(
                  width: 10,
                ),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Color _getStatusColor(String? state) {
  switch (state) {
    case 'In progress':
      return in_progress;

    case 'Backlog':
      return backlog;

    case 'Done':
      return done;

    case 'Pending':
      return pending;

    default:
      return Colors.black;
  }
}
