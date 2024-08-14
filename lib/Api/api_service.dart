import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<http.Response> sendTokenToApi(String token) async {
    final response = await http.post(
      Uri.parse('https://napro-api.azurewebsites.net/api/users/oauth2-google'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'token': token}),
    );

    return response;
  }
}
