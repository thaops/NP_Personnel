class LeaveType {
  final String id;
  final String name;
  final String code;
  final String description;
  final DateTime createdDate;
  final bool isDeleted;

  LeaveType({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.createdDate,
    required this.isDeleted,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  @override
  String toString() {
    return 'LeaveType(id: $id, name: $name, code: $code, description: $description, createdDate: $createdDate, isDeleted: $isDeleted)';
  }
}
