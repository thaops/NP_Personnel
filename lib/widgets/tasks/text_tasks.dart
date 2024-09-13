// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';

import 'package:hocflutter/styles/gogbal_styles.dart';

class TextTasks extends StatelessWidget {
  final String? text1;
  final String? text2;
  const TextTasks({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (text2) {
      case 'high':
        priorityColor = high;
        break;
      case 'medium':
        priorityColor = medium;
        break;
      case 'low':
        priorityColor = low;
        break;
      default:
        priorityColor = Colors.black;
    }

    Color titleColor;
    switch (text2) {
      case 'in-progress':
        titleColor = in_progress;
        break;
      case 'backlog':
        titleColor = backlog;
        break;
      case 'done':
        titleColor = done;
        break;
      case 'pending':
        titleColor = pending;
        break;
      default:
        titleColor = Colors.black;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1 ?? '',
          style: GogbalStyles.bodyText1,
        ),
        SizedBox(
          height: 10,
        ),
        Text(text2 ?? '',
            style: GogbalStyles.bodyText2.copyWith(color: text1 == 'Trạng thái'? titleColor : priorityColor ))
      ],
    );
    ;
  }
}
