import 'package:flutter/material.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/bottapScreens/add/add_screen.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:go_router/go_router.dart';
class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: dark_blue,
            ),
            child: Align(
              alignment: Alignment.topLeft, // Căn chỉnh về phía trên bên trái
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0), // Thêm padding nếu cần
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Màu chữ trắng để nổi bật
                  ),
                ),
              ),
            ),
          ),

          // Danh sách các mục trong menu
          ListTile(
            leading: Icon(
              Icons.list,
            ), // Icon màu xanh đậm
            title: Text('Đơn xin phép', style: GogbalStyles.bodyText2),
            onTap: () {
              // context.go('/listoff');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
            ),
            title: Text('Thông tin cá nhân', style: GogbalStyles.bodyText2),
            onTap: () {
              // Navigator.pushNamed(context, '/thong-tin-ca-nhan');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: Text('Cài đặt', style: GogbalStyles.bodyText2),
            onTap: () {
              // Navigator.pushNamed(context, '/cai-dat');
            },
          ),
          const Spacer(),
          // Footer có thể thêm logo hoặc nội dung khác
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Phiên bản 1.0.0', style: GogbalStyles.bodyText3),
          ),
        ],
      ),
    );
  }
}
