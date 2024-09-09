import 'package:flutter/material.dart';
import 'package:hocflutter/Api/models/ProjectRes.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';

class ProjectDropdown extends StatefulWidget {
  final List<Project>? projectList;
  final void Function(Project?)? onProjectSelected;
  final Future<void> Function()? onRefresh;

  ProjectDropdown({this.projectList, this.onProjectSelected, this.onRefresh});

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
      if (widget.onProjectSelected != null) {
        widget.onProjectSelected!(_selectedProject);
      }
    }
  }


  void _clearSelection() {
    setState(() {
      _selectedProject = null;
      if (widget.onProjectSelected != null) {
        widget.onProjectSelected!(null);
      }
      if (widget.onRefresh != null) {
        widget.onRefresh!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
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
              hint:  Text("Tất cả"),
              onChanged: (Project? newValue) {
                setState(() {
                  _selectedProject = newValue;
                  if (widget.onProjectSelected != null) {
                    widget.onProjectSelected!(newValue ?? _selectedProject);
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
          ),
          if (_selectedProject != null)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: _clearSelection,
            ),
        ],
      ),
    );
  }
}
