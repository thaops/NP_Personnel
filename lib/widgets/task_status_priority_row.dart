import 'package:flutter/material.dart';

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

  Widget _buildDetailColumn(String label, String value, BuildContext context,
      Function(String) onSelection) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> options;
                    if (label == "Trạng Thái") {
                      options = [
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
                      options = [
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
                    return options;
                  },
                  onSelected: (String selectedValue) {
                    onSelection(selectedValue);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: label == "Trạng Thái"
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.onSurface),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
