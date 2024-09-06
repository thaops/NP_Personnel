import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/sprint_model.dart';

class TaskSprintRow extends StatefulWidget {
  final String label1;
  final List<Sprint>? sprintsList;
  final void Function(Sprint?)? onProjectSelected;

  TaskSprintRow({
    Key? key,
    required this.label1,
    this.sprintsList,
    this.onProjectSelected,
  }) : super(key: key);

  @override
  State<TaskSprintRow> createState() => _TaskSprintRowState();
}

class _TaskSprintRowState extends State<TaskSprintRow> {
  Sprint? _selectedSprint;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final sprints = widget.sprintsList ?? [];
    if (_selectedSprint != null && !sprints.contains(_selectedSprint)) {
      _selectedSprint = null;
    }

    return Center(
      child: Container(
        width: screenWidth ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.label1}:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            SizedBox(height: 10,),
            Container(
              width: screenWidth ,
               decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonFormField<Sprint>(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: 'Select a Sprint',
                ),
                isExpanded: true,
                value: _selectedSprint,
                onChanged: (Sprint? newValue) {
                  setState(() {
                    _selectedSprint = newValue;
                    if (widget.onProjectSelected != null) {
                      widget.onProjectSelected!(newValue);
                    }
                  });
                },
                items: sprints.map((Sprint sprint) {
                  return DropdownMenuItem<Sprint>(
                    value: sprint,
                    child: Text(
                      sprint.title,
                      style: TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
