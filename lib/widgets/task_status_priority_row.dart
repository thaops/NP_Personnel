import 'package:flutter/material.dart';
import 'package:hocflutter/config/constants/colors.dart';

class TaskStatusPriorityRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;
  final Function(String) onStatusSelected;
  final Function(String) onPrioritySelected;

  TaskStatusPriorityRow({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
    required this.onStatusSelected,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn(label1, value1, context, onStatusSelected),
        const SizedBox(width: 16),
        _buildDetailColumn(label2, value2, context, onPrioritySelected),
      ],
    );
  }

  Widget _buildDetailColumn(
    String label,
    String value,
    BuildContext context,
    Function(String) onSelection,
  ) {
    Color titleColor;
    // Determine color based on the label and value
    switch (label) {
      case 'Độ ưu tiên':
        titleColor = _getPriorityColor(value);
        break;
      case 'Trạng Thái':
        titleColor = _getStatusColor(value);
        break;
      default:
        titleColor = Colors.black;
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 1.0,
                color: Colors.grey.shade400,
              ),
            ),
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return _getMenuItems(label);
              },
              onSelected: (String selectedValue) {
                onSelection(selectedValue);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.onSurface),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String value) {
    switch (value) {
      case 'high':
        return high; // Define these colors in your constants
      case 'medium':
        return medium;
      case 'low':
        return low;
      default:
        return Colors.black;
    }
  }

  Color _getStatusColor(String value) {
    switch (value) {
      case 'in-progress':
        return in_progress; // Define these colors in your constants
      case 'backlog':
        return backlog;
      case 'done':
        return done;
      case 'pending':
        return pending;
      default:
        return Colors.black;
    }
  }

  List<PopupMenuEntry<String>> _getMenuItems(String label) {
    if (label == "Trạng Thái") {
      return [
        PopupMenuItem<String>(
          value: 'backlog',
          child: Row(
            children: [
              Icon(Icons.hourglass_empty, color: Colors.orange),
              const SizedBox(width: 8),
              Text('Backlog'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'in-progress',
          child: Row(
            children: [
              Icon(Icons.hourglass_top, color: Colors.blue),
              const SizedBox(width: 8),
              Text('In Progress'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'pending',
          child: Row(
            children: [
              Icon(Icons.pending, color: Colors.red),
              const SizedBox(width: 8),
              Text('Pending'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'done',
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text('Done'),
            ],
          ),
        ),
      ];
    } else {
      return [
        PopupMenuItem<String>(
          value: 'high',
          child: Row(
            children: [
              Icon(Icons.priority_high, color: Colors.red),
              const SizedBox(width: 8),
              Text('High'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'medium',
          child: Row(
            children: [
              Icon(Icons.arrow_drop_down, color: Colors.orange),
              const SizedBox(width: 8),
              Text('Medium'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'low',
          child: Row(
            children: [
              Icon(Icons.arrow_drop_down, color: Colors.green),
              const SizedBox(width: 8),
              Text('Low'),
            ],
          ),
        ),
      ];
    }
  }
}
