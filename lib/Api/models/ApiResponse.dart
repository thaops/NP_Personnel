class ApiResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final UserData? data; // Sử dụng UserData? để chấp nhận giá trị null

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data, // Để data có thể là null
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'] ?? 0, // Cung cấp giá trị mặc định nếu giá trị null
      message: json['message'] ?? '', // Cung cấp giá trị mặc định nếu giá trị null
      totalRecord: json['totalRecord'] ?? 0, // Cung cấp giá trị mặc định nếu giá trị null
      data: json['data'] != null ? UserData.fromJson(json['data']) : null, // Kiểm tra null
    );
  }
}

class UserData {
  final String userId;
  final String accessToken;
  final String refreshToken;

  UserData({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] ?? '', // Cung cấp giá trị mặc định nếu giá trị null
      accessToken: json['accessToken'] ?? '', // Cung cấp giá trị mặc định nếu giá trị null
      refreshToken: json['refreshToken'] ?? '', // Cung cấp giá trị mặc định nếu giá trị null
    );
  }
}
