// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hocflutter/src/Api/models/employee_model.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:intl/intl.dart';

class ListWidgets extends StatefulWidget {
  final List<Employee>? listOff;
  const ListWidgets({
    Key? key,
    this.listOff,
  }) : super(key: key);

  @override
  State<ListWidgets> createState() => _ListWidgetsState();
}

class _ListWidgetsState extends State<ListWidgets> {
  final DateFormat dateFormat = DateFormat("dd-MM");
  String avatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
  @override
  Widget build(BuildContext context) {
    if (widget.listOff == null || widget.listOff!.isEmpty) {
      return const Center(
        child: Text("Không có dữ liệu"),
      );
    }
    return Container(
      child: ListView.builder(
        itemCount: widget.listOff!.length,
        itemBuilder: (context, index) {
          final employee = widget.listOff![index];
          return _buildEmployeeItem(employee);
        },
      ),
    );
  }

  // Tạo phương thức để xác định màu sắc
  Color _getStatusColor(String? statusLabel) {
    switch (statusLabel) {
      case 'Đang xử lý':
        return Color.fromARGB(255, 158, 158, 4);
      case 'Đã duyệt':
        return Colors.green;
      case 'Chờ xử lý':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  // Tạo widget cho từng item trong danh sách
  Widget _buildEmployeeItem(Employee employee) {
    final titleColor = _getStatusColor(employee.statusLabel);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      employee?.avatarUrl ?? avatar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.category ?? 'Không lý do',
                        style: GogbalStyles.bodyText2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('${dateFormat.format(employee.fromDate)} - ${dateFormat.format(employee.toDate)}',style: GogbalStyles.bodyText3,)
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    employee.statusLabel ?? 'Chưa có thông tin',
                    style: TextStyle(color: titleColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.arrow_drop_down, size: 24),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
