class Profile {
  // Các thuộc tính khác
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String tel;
  final String department;
  final String departmentId;
  final DateTime workStartDate;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.tel,
    required this.department,
    required this.departmentId,
    required this.workStartDate,
    required this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      address: json['address'],
      tel: json['tel'],
      department: json['department'],
      departmentId: json['departmentId'],
      workStartDate: DateTime.parse(json['workStartDate']),
      avatarUrl: json['avatarUrl'],
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, fullName: $fullName, email: $email, address: $address, tel: $tel, department: $department, departmentId: $departmentId, workStartDate: $workStartDate, avatarUrl: $avatarUrl)';
  }
}
