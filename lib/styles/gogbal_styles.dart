import 'package:flutter/material.dart';

class GogbalStyles {
  // Kiểu chữ tiêu đề chính
  static const TextStyle heading1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Kiểu chữ tiêu đề phụ
  static const TextStyle heading2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

    static const TextStyle heading3 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Kiểu chữ nội dung chính
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  // Kiểu chữ nội dung phụ
  static const TextStyle bodyText2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
    static const TextStyle bodyText3 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );


  // Kiểu chữ cho nút
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static  BoxDecoration commonBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
);

}
