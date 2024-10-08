import 'package:flutter/material.dart';

class TaskTitleSection extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String title;
  final double screenWidth;

  TaskTitleSection({
    required this.controller,
    required this.label,
    required this.title,
    required this.screenWidth,
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
        SizedBox(height: 10,),
        GestureDetector(
          onTap: () {
            print('Tiêu đề công việc nhấp vào');
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              width: screenWidth,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey.shade400
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
