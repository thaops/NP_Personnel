import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/profileModel.dart';
import 'package:hocflutter/config/router/router.dart';
import 'package:hocflutter/screens/bottapScreens/add_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
import 'package:hocflutter/styles/gogbal_styles.dart';
import 'package:hocflutter/widgets/tasks/text_tasks.dart';
import 'package:hocflutter/widgets/tasks/wiget_row.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  Profile? profile;
  String avatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
  bool _isVision = true;
  int _clickCount = 0;
  

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final accessToken = apiService.accessTokenId;

      if (accessToken.isNotEmpty) {
        final response = await _apiService.getProfile(accessToken, context);
        if (response != null) {
          setState(() {
            profile = response;
          });
        } else {
          print('No user data found.');
        }
      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> _onRefresh() async {
    await fetchUsers();
  }

  Future<void> _onVision(BuildContext context) async {
     _clickCount++; 
    if (_clickCount == 6) {
      final shouldSignOut = await showDialog<bool>(
        context: context,
        barrierDismissible:
            false, // Ngăn người dùng đóng hộp thoại bằng cách nhấn ngoài nó
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận đổi sang dev'),
            content: Text('Bạn có muốn đổi sang dev không?'),
            actions: <Widget>[
              TextButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Đóng hộp thoại và trả về false
                },
              ),
              TextButton(
                child: Text('Đồng ý'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Đóng hộp thoại và trả về true
                },
              ),
            ],
          );
        },
      );

      if (shouldSignOut == true) {
        final apiService = Provider.of<ApiService>(context, listen: false);
        apiService.setIsVision(!apiService.isVision);
        await _authService.signOut();
        context.go('/login', extra: {'replace': true});
      }
       _clickCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final isVisiona = apiService.isVision;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh, // Thực hiện khi kéo xuống
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        profile?.avatarUrl ?? avatar,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 30),
                    TextTasks(
                      text1: profile?.fullName ?? ' Name',
                      text2: profile?.department ?? ' Department',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      WigetRow(icon: Icons.phone, name: profile?.tel),
                      WigetRow(icon: Icons.email, name: profile?.email),
                      WigetRow(
                          icon: Icons.location_on_sharp,
                          name: profile?.address),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
                onTap: () {
                  _onVision(context);
                },
                child: Center(
                    child: Text(
                  isVisiona
                      ? "@NPP - Phiên bản - 1.0.0"
                      : "@NPP - Phiên bản - dev",
                  style: GogbalStyles.bodyText3,
                )))
          ],
        ),
      ),
    );
  }
}
