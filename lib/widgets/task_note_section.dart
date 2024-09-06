// lib/widgets/note_section.dart

import 'package:flutter/material.dart';

class TaskNoteSection extends StatelessWidget {
  final TextEditingController controllerNote;
  final String label;
  final String note;
  final double screenWidth;

  TaskNoteSection({
    required this.label,
    required this.note,
    required this.screenWidth,
    required this.controllerNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Colors.grey.shade400,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: TextField(
                  controller: controllerNote,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    controllerNote.text = text;
                  },
                  maxLines: null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
