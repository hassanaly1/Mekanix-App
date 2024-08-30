import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  late TabController tabController;

  final SideMenuController sideMenu = Get.put(SideMenuController());
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    // fetchUserAnalyticsData();
    sideMenu.addListener((index) {
      tabController.animateTo(index,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
      currentPage.value = sideMenu.currentPage;
      debugPrint('CurrentPage: ${currentPage.value}');
    });
    super.onInit();
  }
}
