class ApiResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final Data? data; 
  final String? accessToken;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data,
    this.accessToken,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final dataJson =
        json['data'] != null ? json['data'] as Map<String, dynamic> : null;
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      totalRecord: json['totalRecord'],
      data: dataJson != null
          ? Data.fromJson(dataJson)
          : null, 
      accessToken: dataJson?['accessToken'], 
    );
  }
}

class Data {
  final String userId;
  final String accessToken;
  final String refreshToken;

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
