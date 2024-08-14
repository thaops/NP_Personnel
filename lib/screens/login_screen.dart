import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/screens/home_screen.dart';
import 'package:hocflutter/services/lib/services/auth_service.dart';
import 'package:hocflutter/widgets/custom_text_field.dart';
import 'package:hocflutter/widgets/google_sign_in_button.dart';


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
              hintText: 'Pass',
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            GoogleSignInButton(
              onPressed: () async {
                try {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    // Lấy GoogleSignInAuthentication từ user
                    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                    String? accessToken = googleAuth.accessToken;
                    if (accessToken != null) {
                      var response = await _apiService.sendTokenToApi(accessToken);
                      print("Access Token: $accessToken");
                      if (response.statusCode == 200) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Xác thực thất bại')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể lấy access token')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng nhập thất bại')),
                    );
                  }
                } catch (e) {
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
