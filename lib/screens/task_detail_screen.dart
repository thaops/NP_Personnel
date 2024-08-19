import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/task.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Task: ${task.title}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow("Creator", '${task.creator}', context),
            SizedBox(height: 16),
            _buildStatusPriorityRow("Status", '${task.state}', "Priority", '${task.priority}', context),
            SizedBox(height: 16),
            _buildDateRow("Start Date", task.startDate, "Due Date", task.dueDate, context),
            SizedBox(height: 16),
            _buildNoteSection('Note: ', '${task.note}', context),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Widget _buildInfoRow(String label1, String value1, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label1: ',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value1,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPriorityRow(String label1, String value1, String label2, String value2, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn(label1, value1, context),
        _buildDetailColumn(label2, value2, context),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w500,
              color: label == "Status" ? Colors.green : Colors.amberAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label1, DateTime date1, String label2, DateTime date2, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateDetailColumn(label1, date1, context),
        _buildDateDetailColumn(label2, date2, context),
      ],
    );
  }

  Widget _buildDateDetailColumn(String label, DateTime dateTime, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatDate(dateTime),
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade600,
            ),
          ),
          Text(
            _formatTime(dateTime),
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(String label, String note, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            note,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
