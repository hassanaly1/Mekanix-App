import 'dart:convert';
import 'dart:typed_data';

import 'package:app/controllers/custom_task_controller.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/models/custom_task_model.dart';
import 'package:app/services/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskResponse {
  final bool isSuccess;
  final List<String> data;

  TaskResponse({required this.isSuccess, required this.data});
}

class TaskService {
  Future<bool> createCustomTask({
    required Map<String, dynamic> taskData,
  }) async {
    debugPrint('AddingCustomTask');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.createCustomTaskUrl}'),
        headers: headers,
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('Response Data: $responseData');
        final taskId = responseData['form']['_id'];
        debugPrint('Created Task ID: $taskId');
        CustomTaskController().getAllCustomTasks(page: 1);
        CustomTaskController().getAllCustomTasks(page: 1, isTemplate: true);
        await _updateTaskId(taskId);
        return responseData['status'] == 'success';
      } else {
        debugPrint('Failed to add task, status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  Future<bool> createCustomTemplate({
    required Map<String, dynamic> taskData,
  }) async {
    debugPrint('AddingCustomTemplate');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.createCustomTaskUrl}'),
        headers: headers,
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('Response Data: $responseData');
        final taskId = responseData['template']['_id'];
        debugPrint('Created Task ID: $taskId');
        CustomTaskController().getAllCustomTasks(page: 1);
        CustomTaskController().getAllCustomTasks(page: 1, isTemplate: true);
        // await _updateTaskId(taskId);
        return responseData['status'] == 'success';
      } else {
        debugPrint('Failed to add task, status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  Future<void> _updateTaskId(String taskId) async {
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.createCustomTaskSendIdUrl}'),
        headers: headers,
        body: jsonEncode({'_id': taskId}),
      );

      if (response.statusCode == 200) {
        debugPrint('Task ID updated successfully ${response.statusCode}');
      } else {
        debugPrint(
            'Failed to update task ID, status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating task ID: $e');
    }
  }

  Future<TaskResponse> addCustomTaskFiles({
    required List<Uint8List> attachments,
  }) async {
    debugPrint('AddingCustomTaskFiles');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.addCustomTaskFilesUrl}'),
    );

    for (int i = 0; i < attachments.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        attachments[i],
        filename: 'file_$i.png',
      ));
    }

    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      debugPrint('${response.reasonPhrase} ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        var jsonData = jsonDecode(data);
        bool isSuccess = jsonData['status'] == 'success';
        List<String> files = List<String>.from(jsonData['data']);
        return TaskResponse(isSuccess: isSuccess, data: files);
      } else {
        debugPrint('Error: ${response.reasonPhrase} ${response.statusCode}');
        return TaskResponse(isSuccess: false, data: []);
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
      return TaskResponse(isSuccess: false, data: []);
    }
  }

  Future<List<MyCustomTask>> getAllCustomTasks(
      {String? searchString,
      required String token,
      required int page,
      required bool isTemplate}) async {
    debugPrint('GettingAllCustomTasks');
    String apiUrl =
        '${ApiEndPoints.baseUrl}${ApiEndPoints.getAllCustomTaskUrl}?page=$page&limit=10';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'search': searchString == '' ? null : searchString,
          "is_template": isTemplate,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          final List tasksList = jsonData['data'];
          List<MyCustomTask> tasks = [];
          for (var task in tasksList) {
            tasks.add(MyCustomTask.fromMap(task));
          }
          return tasks;
        } else {
          debugPrint('No tasks found in the request response');
          return [];
        }
      } else {
        debugPrint('Failed to get tasks: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting tasks: $e');
      return [];
    }
  }

  Future<bool> deleteTaskById({
    required String taskId,
    required String token,
  }) async {
    bool isSuccess = false;
    print(taskId);
    final Uri apiUrl = Uri.parse(
      '${ApiEndPoints.baseUrl}${ApiEndPoints.deleteCustomTaskUrl}?id=$taskId',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final http.Response response = await http.delete(
        apiUrl,
        headers: headers,
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);

        if (responseData is Map) {
          debugPrint('Response is a Map: $responseData');

          final String message = responseData['message'];
          dynamic data = responseData['data'];

          // Check if data is a List and handle accordingly
          if (data is List) {
            if (data.isEmpty) {
              debugPrint('Data is an empty list');
              data = {}; // Set data to an empty map if it's an empty list
            } else {
              debugPrint('Data is a list: $data');
              // Handle non-empty list case if needed
            }
          } else if (data is Map) {
            debugPrint('Data is a map: $data');
          } else {
            debugPrint('Unexpected data type: ${data.runtimeType}');
            data = {}; // Fallback to an empty map
          }

          debugPrint('Task deletion message: $message');
          debugPrint('Deleted Task details: $data');
          isSuccess = true;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }
      } else {
        debugPrint(
            'Failed to delete task. Status Code: ${response.statusCode} ${response.reasonPhrase}');
        debugPrint('Response Body: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error deleting task: $error');
    }

    return isSuccess;
  }

  Future<bool> updateCustomTask({
    required Map<String, dynamic> taskData,
    required String taskId,
  }) async {
    debugPrint('AddingCustomTask');
    var token = storage.read('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    debugPrint('Updating task with id: $taskId');
    debugPrint('Updating task data: ${jsonEncode(taskData)}');
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.updateCustomTaskUrl}?id=$taskId'),
        headers: headers,
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint(responseData['message']);
        return responseData['status'] == 'success';
      } else {
        debugPrint(
            'Failed to update task, status code: ${response.statusCode} ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }
}
