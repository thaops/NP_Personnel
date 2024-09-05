import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/Users.dart';

class TaskInfoRow extends StatefulWidget {
  final String label1;
  final List<User>? usersList;
  final void Function(User?)? onProjectSelected;

  TaskInfoRow({
    Key? key,
    required this.label1,
    this.usersList,
    this.onProjectSelected,
  }) : super(key: key);

  @override
  State<TaskInfoRow> createState() => _TaskInfoRowState();
}

class _TaskInfoRowState extends State<TaskInfoRow> {
  User? _selectedUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.label1}:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        Container(
          width: screenWidth * 0.6,
          child: DropdownButtonFormField<User>(
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
              hintText: 'Select a Project',
            ),
            isExpanded: true,
            value: _selectedUser,
            onChanged: (User? newValue) {
              setState(() {
                _selectedUser = newValue;
                if (widget.onProjectSelected != null) {
                  widget.onProjectSelected!(newValue);
                }
              });
            },
            items: widget.usersList?.map((User user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text(
                      user.fullName,
                      style: TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ),
      ],
    );
  }
}
