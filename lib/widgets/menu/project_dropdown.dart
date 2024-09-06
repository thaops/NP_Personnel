import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';

class ProjectDropdown extends StatefulWidget {
  final List<Project>? projectList;
  final void Function(Project?)? onProjectSelected;

  ProjectDropdown({this.projectList, this.onProjectSelected});

  @override
  _ProjectDropdownState createState() => _ProjectDropdownState();
}

class _ProjectDropdownState extends State<ProjectDropdown> {
  Project? _selectedProject;

  @override
  void initState() {
    super.initState();
    if (widget.projectList != null && widget.projectList!.isNotEmpty) {
      _selectedProject = widget.projectList!.first;
      // Gọi onProjectSelected với item đầu tiên nếu có
      if (widget.onProjectSelected != null) {
        widget.onProjectSelected!(_selectedProject);
      }
    }
  }

  @override
  void didUpdateWidget(covariant ProjectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.projectList != null &&
        widget.projectList != oldWidget.projectList &&
        widget.projectList!.isNotEmpty) {
      _selectedProject = widget.projectList![2];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth ,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: DropdownButtonFormField<Project>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        value: _selectedProject,
        onChanged: (Project? newValue) {
          setState(() {
            _selectedProject = newValue;
            if (widget.onProjectSelected != null) {
              widget.onProjectSelected!(newValue);
            }
          });
        },
        items: widget.projectList?.map((Project project) {
          return DropdownMenuItem<Project>(
            value: project,
            child: Text(
              project.name, // Hiển thị tên dự án
              style: TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }
}
