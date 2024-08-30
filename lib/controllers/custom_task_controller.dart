import 'package:flutter/material.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/models/custom_task_model.dart';
import 'package:app/services/task_service.dart';
import 'package:get/get.dart';

class CustomTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isTasksAreLoading = false.obs;
  RxBool isTemplatesAreLoading = false.obs;
  RxBool isTemplate = false.obs;
  RxBool isForm = false.obs;
  var submittedTasks = <MyCustomTask>[].obs;
  var templates = <MyCustomTask>[].obs;
  final RxInt currentPage = 1.obs;

  final RxInt currentPageTasks = 1.obs;
  final RxInt currentPageTemplates = 1.obs;

  ScrollController reportsScrollController = ScrollController();
  ScrollController templatesScrollController = ScrollController();

  // TextEditingController searchController = TextEditingController();
  final TaskService _taskService = TaskService();

  RxString engineBrandId = ''.obs;
  RxString engineBrandName = ''.obs;

  @override
  onInit() {
    reportsScrollController.addListener(() {
      if (reportsScrollController.position.pixels ==
          reportsScrollController.position.maxScrollExtent) {
        if (!isTasksAreLoading.value) {
          loadNextPageTasks();
        }
      }
    });
    templatesScrollController.addListener(() {
      if (templatesScrollController.position.pixels ==
          templatesScrollController.position.maxScrollExtent) {
        if (!isTemplatesAreLoading.value) {
          loadNextPageTemplates();
        }
      }
    });
    super.onInit();
  }

  Future<void> loadNextPageTasks() async {
    debugPrint('Loading Next Page ${currentPageTasks.value} Tasks');
    isTasksAreLoading.value = true;

    List<MyCustomTask> nextPageTasks = await _taskService.getAllCustomTasks(
      searchString: '',
      token: storage.read('token'),
      page: currentPageTasks.value,
      isTemplate: false,
    );

    Set<String?> existingTasksIds =
        submittedTasks.map((task) => task.id).toSet();
    for (var task in nextPageTasks) {
      if (!existingTasksIds.contains(task.id)) {
        submittedTasks.add(task);
        existingTasksIds.add(task.id);
      }
    }

    if (nextPageTasks.length >= 10) {
      currentPageTasks.value++;
    }

    isTasksAreLoading.value = false;
  }

  Future<void> loadNextPageTemplates() async {
    debugPrint('Loading Next Page ${currentPageTemplates.value} Templates');
    isTemplatesAreLoading.value = true;

    List<MyCustomTask> nextPageTemplates = await _taskService.getAllCustomTasks(
      searchString: '',
      token: storage.read('token'),
      page: currentPageTemplates.value,
      isTemplate: true,
    );

    Set<String?> existingTemplatesIds =
        templates.map((template) => template.id).toSet();
    for (var template in nextPageTemplates) {
      if (!existingTemplatesIds.contains(template.id)) {
        templates.add(template);
        existingTemplatesIds.add(template.id);
      }
    }

    if (nextPageTemplates.length >= 10) {
      currentPageTemplates.value++;
    }

    isTemplatesAreLoading.value = false;
  }

  Future<void> getAllCustomTasks(
      {String? searchName, int? page, bool isTemplate = false}) async {
    debugPrint(
        'Page${page ?? currentPage.value} ${isTemplate ? 'Template' : 'Submitted'} tasks called.');
    try {
      templates.clear();
      submittedTasks.clear();
      isLoading.value = true;
      List<MyCustomTask> fetchedTasks = await _taskService.getAllCustomTasks(
        searchString: searchName ?? '',
        token: storage.read('token'),
        page: page ?? currentPage.value,
        isTemplate: isTemplate,
      );

      debugPrint(
          '${isTemplate ? 'Templates' : 'Submitted Tasks'}: ${fetchedTasks.length}');

      if (isTemplate) {
        templates.assignAll(fetchedTasks);
      } else {
        submittedTasks.assignAll(fetchedTasks);
      }
    } catch (e) {
      debugPrint('Error fetching Tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCustomTask({taskId}) async {
    isLoading.value = true;
    try {
      bool taskDeleted = await _taskService.deleteTaskById(
        taskId: taskId,
        token: storage.read('token'),
      );

      if (taskDeleted) {
        getAllCustomTasks(page: 1);
        getAllCustomTasks(page: 1, isTemplate: true);
        ToastMessage.showToastMessage(
            message: 'Task Deleted Successfully',
            backgroundColor: Colors.green);
        Get.back();
      } else {
        Get.back();
        ToastMessage.showToastMessage(
            message: 'Failed to delete task, please try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.back();
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);
      debugPrint('Error deleting task: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
