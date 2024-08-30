import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  Future<Map<String, dynamic>> fetchAnalyticsData() async {
    String apiUrl = '${ApiEndPoints.baseUrl}${ApiEndPoints.getAnalyticsUrl}';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${storage.read('token')}',
      },
    );
    debugPrint('StatusCode: ${response.statusCode} + ${response.reasonPhrase}');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
