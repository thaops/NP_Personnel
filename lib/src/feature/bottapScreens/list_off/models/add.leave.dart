class ResponseModel {
  final int statusCode;
  final String message;
  final int totalRecord;
  final bool data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      totalRecord: json['totalRecord'] as int,
      data: json['data'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'totalRecord': totalRecord,
      'data': data,
    };
  }
}
