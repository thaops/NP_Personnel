// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hocflutter/src/Api/models/users_model.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/models/leave.dart';

class ListoffLeave extends StatefulWidget {
  final String label1;
  final String? name;
  final List<LeaveType>? leaveList;
  final void Function(LeaveType?)? onProjectSelected;

  ListoffLeave({
    Key? key,
    required this.label1,
    this.name,
    this.leaveList,
    this.onProjectSelected,
  }) : super(key: key);

  @override
  State<ListoffLeave> createState() => _ListoffLeaveState();
}

class _ListoffLeaveState extends State<ListoffLeave> {
  LeaveType? _selectedUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
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
          SizedBox(
            height: 10,
          ),
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonFormField<LeaveType>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
               
              ),
              isExpanded: true,
              value: _selectedUser,
              hint: Text(widget.name ?? 'lý do?'),
              onChanged: (LeaveType? newValue) {
                setState(() {
                  _selectedUser = newValue;
                  if (widget.onProjectSelected != null) {
                    widget.onProjectSelected!(newValue);
                  }
                });
              },
              items: widget.leaveList?.map((LeaveType user) {
                    return DropdownMenuItem<LeaveType>(
                      value: user,
                      child: Text(
                        user.name,
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}
