import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/models/engine_model.dart';
import 'package:app/models/user_activities.dart';
import 'package:app/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UniversalController extends GetxController {
  List<EngineModel> engines = <EngineModel>[].obs;

  XFile? userImage;
  RxString userImageURL = ''.obs;
  Uint8List? userImageInBytes;
  RxMap userInfo = {}.obs;

  var isLoading = false.obs;
  var isFormsAreLoading = false.obs;
  var isEnginesAreLoading = false.obs;
  var isTemplatesAreLoading = false.obs;
  var templateCount = 0.obs;
  var formCount = 0.obs;
  var engineCount = 0.obs;
  var templateAnalytics = <Analytic>[].obs;
  var formAnalytics = <Analytic>[].obs;
  var engineAnalytics = <Analytic>[].obs;

  set setUserImageUrl(String value) {
    userImageURL.value = value;
    update();
  }

  final RxInt currentPage = 1.obs;

  @override
  void onInit() async {
    super.onInit();
    userInfo.value = storage.read('user_info') ?? {};
    userImageURL.value = storage.read('user_info')['profile'];
    debugPrint('UserImageAtStart: $userImageURL');
    fetchUserAnalyticsData();
  }

  updateUserInfo(Map<String, dynamic> userInfo) {
    this.userInfo.value = userInfo;
    storage.write('user_info', userInfo);
  }

  void fetchUserAnalyticsData() async {
    try {
      isLoading(true);
      isFormsAreLoading(true);
      isEnginesAreLoading(true);
      isTemplatesAreLoading(true);

      var result = await DashboardService().fetchAnalyticsData();
      var userActivities = UserActivities.fromJson(result['data']);

      templateCount.value = userActivities.templatesCount ?? 0;
      formCount.value = userActivities.formsCount ?? 0;
      engineCount.value = userActivities.enginesCount ?? 0;
      templateAnalytics.assignAll(userActivities.templateAnalytics ?? []);
      formAnalytics.assignAll(userActivities.formAnalytics ?? []);
      engineAnalytics.assignAll(userActivities.engineAnalytics ?? []);
    } finally {
      isLoading(false);
      isFormsAreLoading(false);
      isEnginesAreLoading(false);
      isTemplatesAreLoading(false);
    }
  }
}
