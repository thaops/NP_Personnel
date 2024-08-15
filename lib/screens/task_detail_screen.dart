import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Description: ${task.description}'),
            SizedBox(height: 10),
            Text('State: ${task.state}'),
            SizedBox(height: 10),
            Text('Priority: ${task.priority}'),
            SizedBox(height: 10),
            Text('Creator: ${task.creator}'),
            SizedBox(height: 10),
            Text('Start Date: ${task.startDate}'),
            SizedBox(height: 10),
            Text('Due Date: ${task.dueDate}'),
          ],
        ),
      ),
    );
  }
}
