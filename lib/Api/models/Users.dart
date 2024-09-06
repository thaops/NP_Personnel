import 'dart:convert';

class UserModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String department;
  final int? userType;
  final String userTypeLabel;
  final String bankInfo;
  final String email;
  final String? tel;
  final DateTime startDate;
  final String? cccd;
  final DateTime? licenseDate;
  final String? licensePlace;
  final DateTime? signedDate;
  final DateTime? expiredDate;

  UserModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.department,
    this.userType,
    required this.userTypeLabel,
    required this.bankInfo,
    required this.email,
    this.tel,
    required this.startDate,
    this.cccd,
    this.licenseDate,
    this.licensePlace,
    this.signedDate,
    this.expiredDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      department: json['department'],
      userType: json['userType'],
      userTypeLabel: json['userTypeLabel'],
      bankInfo: json['bankInfo'],
      email: json['email'],
      tel: json['tel'],
      startDate: DateTime.parse(json['startDate']),
      cccd: json['cccd'],
      licenseDate: json['licenseDate'] != null
          ? DateTime.parse(json['licenseDate'])
          : null,
      licensePlace: json['licensePlace'],
      signedDate: json['signedDate'] != null
          ? DateTime.parse(json['signedDate'])
          : null,
      expiredDate: json['expiredDate'] != null
          ? DateTime.parse(json['expiredDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'department': department,
      'userType': userType,
      'userTypeLabel': userTypeLabel,
      'bankInfo': bankInfo,
      'email': email,
      'tel': tel,
      'startDate': startDate.toIso8601String(),
      'cccd': cccd,
      'licenseDate': licenseDate?.toIso8601String(),
      'licensePlace': licensePlace,
      'signedDate': signedDate?.toIso8601String(),
      'expiredDate': expiredDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, department: $department, userType: $userType, userTypeLabel: $userTypeLabel, bankInfo: $bankInfo, email: $email, tel: $tel, startDate: $startDate, cccd: $cccd, licenseDate: $licenseDate, licensePlace: $licensePlace, signedDate: $signedDate, expiredDate: $expiredDate)';
  }
}
