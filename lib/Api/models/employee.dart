class Employee {
  final String id;
  final String employeeId;
  final String? department;
  final String? avatarUrl;
  final String fullName;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDay;
  final String? categoryId;
  final String category;
  final int status;
  final String statusLabel;
  final DateTime? approvalDate;
  final DateTime? lastApprovalDate;
  final String reason;
  final String? note;
  final DateTime createdDate;
  final bool isDeleted;

  Employee({
    required this.id,
    required this.employeeId,
    this.department,
    this.avatarUrl,
    required this.fullName,
    required this.fromDate,
    required this.toDate,
    required this.totalDay,
    this.categoryId,
    required this.category,
    required this.status,
    required this.statusLabel,
    this.approvalDate,
    this.lastApprovalDate,
    required this.reason,
    this.note,
    required this.createdDate,
    required this.isDeleted,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      department: json['department'],
      avatarUrl: json['avatarUrl'],
      fullName: json['fullName'] ?? '',
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      totalDay: json['totalDay'] ?? 0,
      categoryId: json['categoryId'],
      category: json['category'] ?? '',
      status: json['status'] ?? 0,
      statusLabel: json['statusLabel'] ?? '',
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      lastApprovalDate: json['lastApprovalDate'] != null
          ? DateTime.parse(json['lastApprovalDate'])
          : null,
      reason: json['reason'] ?? '',
      note: json['note'],
      createdDate: DateTime.parse(json['createdDate']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Employee{id: $id, employeeId: $employeeId, department: $department, avatarUrl: $avatarUrl, '
        'fullName: $fullName, fromDate: $fromDate, toDate: $toDate, totalDay: $totalDay, '
        'categoryId: $categoryId, category: $category, status: $status, statusLabel: $statusLabel, '
        'approvalDate: $approvalDate, lastApprovalDate: $lastApprovalDate, reason: $reason, '
        'note: $note, createdDate: $createdDate, isDeleted: $isDeleted}';
  }
}
