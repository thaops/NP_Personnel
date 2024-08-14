class ApiResponse {
  int statusCode;
  String message;
  int totalRecord;
  Data? data;
  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
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
