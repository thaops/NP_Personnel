class taskResponse {
  int statusCode;
  String message;
  int totalRecord;
  String data;

  taskResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  // Phương thức từ JSON sang đối tượng Dart
  factory taskResponse.fromJson(Map<String, dynamic> json) {
    return taskResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      totalRecord: json['totalRecord'],
      data: json['data'],
    );
  }

  // Phương thức từ đối tượng Dart sang JSON
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'totalRecord': totalRecord,
      'data': data,
    };
  }
}
