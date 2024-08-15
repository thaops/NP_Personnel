class ApiResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final Map<String, dynamic>? data;
  final String? accessToken; // Thêm thuộc tính này

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data,
    this.accessToken,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      totalRecord: json['totalRecord'],
      data: json['data'],
      accessToken: json['data']?['accessToken'], // Lấy accessToken từ dữ liệu JSON
    );
  }
}


class Data {
  String userId;
  String accessToken;
  String refreshToken;

  Data({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
