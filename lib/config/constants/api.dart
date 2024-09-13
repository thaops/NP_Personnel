import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hocflutter/Api/api_service.dart';

class BaseUrlProvider {
  static String getBaseUrl(BuildContext context) {
    final ApiService apiService = Provider.of<ApiService>(context, listen: false);
    final bool isVision = apiService.isVision;

    final String baseUrlDev = 'https://napro-api.azurewebsites.net/api';
    final String baseUrlNp = 'https://napro-api.azurewebsites.net/api';

    return isVision ? baseUrlNp : baseUrlDev;
  }
}
