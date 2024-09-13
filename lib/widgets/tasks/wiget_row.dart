// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WigetRow extends StatefulWidget {
  final String? name;
  final IconData? icon;
  final VoidCallback? onTap;
  const WigetRow({
    Key? key,
    this.name,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  State<WigetRow> createState() => _WigetRowState();
}

class _WigetRowState extends State<WigetRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(widget.icon ?? Icons.person),
            SizedBox(
              width: 30,
            ),
            Text(widget.name ?? 'Nhân Viên')
          ],
        ),
      ),
    );
  }
}
