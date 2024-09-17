import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:hocflutter/src/feature/router/router.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/view/home_screen.dart';
import 'package:hocflutter/src/services/lib/services/auth_service.dart';
import 'package:hocflutter/widgets/text/custom_text_field.dart';
import 'package:hocflutter/widgets/google/google_sign_in_button.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 150,
              ),
            ),
            SizedBox(height: 30),
            CustomTextField(
              controller: _usernameController,
              hintText: 'Username',
              label: 'Tên Đăng Nhập',
              icon: Icons.account_circle_outlined,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              label: 'Mật Khẩu',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 30),
            Container(
              width: screenWidth,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark_blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tính năng chưa hoàn thiện!')),
                  );
                },
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Hoặc",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),
            GoogleSignInButton(
              onPressed: () async {
                // Hiển thị hộp thoại loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    final GoogleSignInAccount? googleUser =
                        await _googleSignIn.signIn();
                    final GoogleSignInAuthentication googleAuth =
                        await googleUser!.authentication;
                    String? accessToken = googleAuth.accessToken;
                    if (accessToken != null) {
                      var response = await _apiService.sendTokenToApi(
                          accessToken, context);
                      var accessTokenId = response.accessToken.toString();
                      if (response.statusCode == 200) {
                        Provider.of<ApiService>(context, listen: false)
                            .setAccessTokenId(accessTokenId);
                        // Ẩn loading khi đăng nhập thành công
                        Navigator.pop(context);
                        context.go('/main');
                      } else {
                        Navigator.pop(context); // Ẩn loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Xác thực thất bại')),
                        );
                      }
                    } else {
                      Navigator.pop(context); // Ẩn loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể lấy access token')),
                      );
                    }
                  } else {
                    Navigator.pop(context); // Ẩn loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng nhập thất bại')),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Ẩn loading nếu có lỗi
                  print('Lỗi: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Có lỗi xảy ra')),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
