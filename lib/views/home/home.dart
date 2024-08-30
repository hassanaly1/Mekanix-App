import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/models/user_activities.dart';
import 'package:app/views/home/barchart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final currentIndex = 0.obs;
  late UniversalController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onPageChanged(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      _carouselController.animateToPage(index);
    }
  }

  void _onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Obx(
            () => Column(
              children: [
                context.isPortrait
                    ? CarouselSlider(
                        items: [
                          NewWidget(
                            onTap: () => _pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            title: 'Submitted Tasks',
                            isLoading: controller.isFormsAreLoading.value,
                            value: controller.formCount.toString(),
                          ),
                          NewWidget(
                            onTap: () => _pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            isLoading: controller.isTemplatesAreLoading.value,
                            title: 'Total Templates',
                            value: controller.templateCount.toString(),
                          ),
                          NewWidget(
                            onTap: () => _pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            title: 'Total Engines',
                            isLoading: controller.isEnginesAreLoading.value,
                            value: controller.engineCount.toString(),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 140,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.7,
                          onPageChanged: (index, reason) {
                            if (reason == CarouselPageChangedReason.manual) {
                              _onCarouselPageChanged(index, reason);
                            }
                          },
                        ),
                        carouselController: _carouselController,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NewWidget(
                              onTap: () => _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut),
                              title: 'Submitted Tasks',
                              value: controller.formCount.toString(),
                              isLoading: controller.isFormsAreLoading.value,
                            ),
                            NewWidget(
                              onTap: () => _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut),
                              title: 'Total Templates',
                              value: controller.templateCount.toString(),
                              isLoading: controller.isTemplatesAreLoading.value,
                            ),
                            NewWidget(
                              onTap: () => _pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut),
                              title: 'Total Engines',
                              value: controller.engineCount.toString(),
                              isLoading: controller.isEnginesAreLoading.value,
                            ),
                          ],
                        ),
                      ),
                const Divider(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => _onPageChanged(index),
                    children: [
                      TabView1(
                          title: 'Tasks',
                          pageController: _pageController,
                          data: controller.formAnalytics),
                      TabView1(
                          title: 'Templates',
                          pageController: _pageController,
                          data: controller.templateAnalytics),
                      TabView1(
                          title: 'Engines',
                          pageController: _pageController,
                          data: controller.engineAnalytics),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

class NewWidget extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isLoading;

  const NewWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.value,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: ReUsableContainer(
          height: 100,
          width: 240,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(text: title, fontSize: 18.0),
              isLoading
                  ? SpinKitThreeBounce(
                      color: AppColors.secondaryColor,
                      size: 25.0,
                    )
                  : CustomTextWidget(
                      text: value,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabView1 extends StatelessWidget {
  final String title;
  final PageController pageController;
  final List<Analytic> data;

  const TabView1(
      {super.key,
      required this.pageController,
      required this.data,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return MyBarChart(data: data, title: title);
  }
}
