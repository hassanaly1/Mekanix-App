import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/models/engine_model.dart';
import 'package:app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;

class EngineService {
  Future<bool> addEngine({
    required EngineModel engineModel,
    required Uint8List engineImageInBytes,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${storage.read('token')}',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.addEngineUrl}'),
    );

    // Add form fields
    request.fields.addAll({
      'engine_brand[user]': '${storage.read('user_info')['_id']}',
      'engine_brand[name]': '${engineModel.name}',
      'engine_brand[subname]': '${engineModel.subname}',
      'engine_brand[is_generator]': '${engineModel.isGenerator}',
      'engine_brand[is_compressor]': '${engineModel.isCompressor}',
    });
    request.files.add(
      http.MultipartFile.fromBytes(
        'engines',
        engineImageInBytes,
        filename: 'engine.png',
      ),
    );

    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        debugPrint(await response.stream.bytesToString());
        return true;
      } else {
        debugPrint(
            '${response.reasonPhrase}  ${response.statusCode} ${response.stream}');
        return false;
      }
    } catch (e) {
      debugPrint('Error adding engine: $e');
      return false;
    }
  }

  Future<List<EngineModel>> getAllEngines(
      {String? searchString, required String token, required int page}) async {
    String apiUrl =
        '${ApiEndPoints.baseUrl}${ApiEndPoints.getEngineUrl}?page=$page';

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'search': {"name": searchString}
        }),
      );
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> responseData = json.decode(response.body);
        // You can now access specific fields within this data using their keys.
        List<dynamic> engineData = responseData['data'][0]['engines'];

        // Map the JSON data to a list of EngineModel objects
        List<EngineModel> engines =
            engineData.map((data) => EngineModel.fromJson(data)).toList();

        return engines;
      } else {
        debugPrint('Failed to get engines: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting engines: $e');
      return [];
    }
  }

  Future<bool> updateEngine({
    required EngineModel engineModel,
    required String token,
  }) async {
    String apiUrl = '${ApiEndPoints.baseUrl}${ApiEndPoints.updateEngineUrl}';
    bool isSuccess = false;

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'engine_brand': engineModel.toJson(),
        }),
      );
      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        debugPrint(message);
        isSuccess = true;
      } else {
        debugPrint(
            'Failed to update engine: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating engine: $e');
    }

    return isSuccess;
  }

  Future<bool> deleteEngine({
    required EngineModel engineModel,
    required String token,
  }) async {
    String apiUrl = '${ApiEndPoints.baseUrl}${ApiEndPoints.deleteEngineUrl}';
    bool isSuccess = false;

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'engine_brand': engineModel.toJson(),
        }),
      );
      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];

        debugPrint(message);
        isSuccess = true;
      } else {
        debugPrint(
            'Failed to delete engine: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting engine: $e');
    }

    return isSuccess;
  }

  Future<String> updateEngineImage({
    required Uint8List engineImageInBytes,
    required String engineId,
    required String token,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.updateEngineImageUrl}?id=$engineId'),
    );
    // Add image file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'engines',
        engineImageInBytes,
        filename: 'engine.png',
      ),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        String responseString = await response.stream.bytesToString();

        debugPrint(responseString);

        final Map<String, dynamic> jsonResponse = json.decode(responseString);
        String url = jsonResponse['data']['engine']['url'];
        debugPrint('Extracted URL: $url');

        return url;
      } else {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again',
            backgroundColor: Colors.red);
        debugPrint(
            'Error updating engine image:${response.statusCode} ${response.reasonPhrase}');
        return '';
      }
    } catch (e) {
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);

      debugPrint('Error updating engine image: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> getEngineData(
      {required String engineName}) async {
    debugPrint('GetEngineDataApiCalled');
    final url =
        '${ApiEndPoints.baseUrl}${ApiEndPoints.getEngineBrandById}?name=$engineName';

    bool success;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        debugPrint(
            'Status Code: ${response.statusCode}, Response: ${response.body}');
        final data = json.decode(response.body);
// Check if the data contains the engine
        if (data['data'] != null && data['data']['engine'] != null) {
          final engineData = data['data']['engine'];
          success = true;
          return {'data': engineData, 'success': success};
        } else {
          final message = data['message'] ?? 'Engine not found';
          success = false;
          return {'data': null, 'message': message, 'success': success};
        }
      } else {
        debugPrint(
            'Status Code: ${response.statusCode}, Response: ${response.body}');
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Unknown error occurred';
        success = false;
        return {'data': null, 'message': message, 'success': success};
      }
    } catch (e) {
      print('Error occurred: $e');
      success = false;
      return {
        'data': null,
        'message': 'An error occurred: $e',
        'success': success
      };
    }

    //WorkingCode
    //   final engineData = data['data']['engine'];
    //   success = true;
    //   return {'data': engineData, 'success': success};
    // } else {
    //   debugPrint(
    //       'Status Code: ${response.statusCode}, Response: ${response.body}');
    //   success = false;
    //   return {'data': null, 'success': success};
    // }
    // } catch (e) {
    //   print('Error occurred: $e');
    //   success = false;
    //   return {'data': null, 'success': success};
    // }
  }
}
