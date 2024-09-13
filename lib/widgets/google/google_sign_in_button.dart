import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google.png',
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Text(
              "Đăng Nhập Với Google",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
