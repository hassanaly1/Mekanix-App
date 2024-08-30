import 'package:app/controllers/custom_task_controller.dart';
import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/dropdown.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/helpers/tabbar.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/models/custom_task_model.dart';
import 'package:app/services/engine_service.dart';
import 'package:app/views/task/custom_task.dart';
import 'package:app/views/task/scan_qrcode.dart';
import 'package:app/views/task/widgets/heading_and_textfield.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TaskScreen extends StatefulWidget {
  final SideMenuController? sideMenu;

  TaskScreen({super.key, this.sideMenu});

  final UniversalController universalController = Get.find();

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late CustomTaskController controller;
  TextEditingController reportNameController = TextEditingController();
  RxInt currentPage = 0.obs;

  @override
  void initState() {
    debugPrint('TaskScreenInitCalled');
    controller = Get.put(CustomTaskController());
    controller.getAllCustomTasks(page: 1);
    controller.getAllCustomTasks(page: 1, isTemplate: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    reportNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          widget.sideMenu?.changePage(0);
          UniversalController universalController = Get.find();
          universalController.fetchUserAnalyticsData();
        },
        child: DefaultTabController(
          length: 2,
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
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: context.height * 0.13,
                      pinned: false,
                      floating: true,
                      primary: false,
                      backgroundColor: Colors.transparent,
                      excludeHeaderSemantics: false,
                      forceMaterialTransparency: false,
                      flexibleSpace: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Obx(
                            () => TopSection(
                              controller: controller,
                              reportNameController: reportNameController,
                              universalController: widget.universalController,
                              currentPage: currentPage.value,
                            ),
                          )
                        ],
                      ),
                    )
                  ];
                },
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTabBar(
                        onTap: (page) {
                          currentPage.value = page;
                          controller.currentPage.value = 1;
                          // currentPage.value == 0
                          //     ? controller.getAllCustomTasks()
                          //     : controller.getAllCustomTasks(isTemplate: true);
                        },
                        title1: 'Submitted Reports',
                        title2: 'Templates',
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          TaskListView(
                            isTemplate: false,
                            controller: controller,
                            universalController: widget.universalController,
                          ),
                          TaskListView(
                            isTemplate: true,
                            controller: controller,
                            universalController: widget.universalController,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final CustomTaskController controller;
  final TextEditingController reportNameController;
  final UniversalController universalController;
  final int currentPage;

  const TopSection({
    super.key,
    required this.controller,
    required this.reportNameController,
    required this.universalController,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: context.width,
              child: ReUsableContainer(
                color: AppColors.primaryColor,
                width: context.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const IconButton(
                      onPressed: null,
                      icon: Icon(FontAwesomeIcons.circlePlus,
                          color: Colors.transparent),
                    ),
                    CustomTextWidget(
                      text: currentPage == 0
                          ? 'Create Report'
                          : 'Create Template',
                      fontSize: 16.0,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () {
                        reportNameController.clear();
                        CustomPopup.show(
                          context: context,
                          reportNameController: reportNameController,
                          controller: controller,
                          universalController: universalController,
                          currentPage: currentPage,
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.circlePlus),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final bool isTemplate;
  final CustomTaskController controller;
  final UniversalController universalController;

  const TaskListView({
    super.key,
    required this.isTemplate,
    required this.controller,
    required this.universalController,
  });

  // Future<void> _refreshTasks() {
  //   return isTemplate
  //       ? controller.getAllCustomTasks(page: 1, isTemplate: true)
  //       : controller.getAllCustomTasks(page: 1);
  // }

  Future<void> _refreshTasks() async {
    if (isTemplate) {
      controller.currentPageTemplates.value = 1;
      controller.templates.clear();
      await controller.loadNextPageTemplates();
    } else {
      controller.currentPageTasks.value = 1;
      controller.submittedTasks.clear();
      await controller.loadNextPageTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshTasks,
      color: AppColors.primaryColor,
      backgroundColor: AppColors.secondaryColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SpinKitThreeBounce(
              color: AppColors.blueTextColor,
              size: 30,
            ),
          );
        } else if (isTemplate
            ? controller.templates.isEmpty
            : controller.submittedTasks.isEmpty) {
          return Center(
            heightFactor: 10.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.height * 0.2),
                  CustomTextWidget(
                    text: isTemplate
                        ? 'No Templates Available'
                        : 'No Submitted Tasks Available',
                  ),
                  SizedBox(height: context.height * 0.5),
                ],
              ),
            ),
          );
        } else {
          final tasks =
              isTemplate ? controller.templates : controller.submittedTasks;
          return ListView.builder(
            controller: isTemplate
                ? controller.templatesScrollController
                : controller.reportsScrollController,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: tasks.length +
                (isTemplate
                    ? (controller.isTemplatesAreLoading.value ? 1 : 0)
                    : (controller.isTasksAreLoading.value ? 1 : 0)),
            itemBuilder: (context, index) {
              if (index < tasks.length) {
                final task = tasks[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: context.width * 0.04),
                  child: ReUsableContainer(
                    child: ListTile(
                      onTap: () {
                        isTemplate
                            ? CustomTemplatePopup.show(
                                context: context,
                                task: task,
                                controller: controller,
                                universalController: universalController,
                              )
                            : Get.to(
                                () => CustomTaskScreen(
                                  reportName: task.name,
                                  task: task,
                                  isTemplate: task.isTemplate,
                                  isDefault: task.isDefault,
                                ),
                              );
                      },
                      trailing: task.isDefault
                          ? null
                          : InkWell(
                              onTap: () {
                                _showDeletePopup(
                                    context: context,
                                    controller: controller,
                                    id: task.id ?? '');
                              },
                              child: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                      leading: CustomTextWidget(
                        text: '${index + 1}'.toString(),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      title: CustomTextWidget(
                        text: !isTemplate
                            ? task.customerName!.isEmpty
                                ? 'No Name Assigned'
                                : task.customerName!
                            : task.name,
                        fontSize: 14.0,
                        maxLines: 2,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: isTemplate
                          ? null
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  fontSize: 12.0,
                                  text: task.name.isEmpty
                                      ? 'No Name Assigned'
                                      : task.name,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColors.lightTextColor,
                                ),
                                CustomTextWidget(
                                  fontSize: 12.0,
                                  text: task.customerEmail!.isEmpty
                                      ? 'No Email Assigned'
                                      : task.customerEmail!,
                                  fontWeight: FontWeight.w300,
                                  textColor: AppColors.lightTextColor,
                                ),
                              ],
                            ),
                      titleAlignment: ListTileTitleAlignment.center,
                    ),
                  ),
                );
              } else if (isTemplate
                  ? controller.isTemplatesAreLoading.value
                  : controller.isTasksAreLoading.value) {
                return const Center(
                  heightFactor: 3,
                  child: SpinKitCircle(color: Colors.black87, size: 40.0),
                );
              } else {
                return Container();
              }
            },
          );
        }
      }),
    );
  }
}

class CustomPopup {
  static void show({
    required BuildContext context,
    required TextEditingController reportNameController,
    required CustomTaskController controller,
    required UniversalController universalController,
    required int currentPage,
  }) {
    showCustomPopup(
      context: context,
      width: context.isLandscape ? context.width * 0.4 : context.width * 0.8,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            text: 'Create New ${currentPage == 0 ? 'Report' : 'Template'}',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12.0),
          HeadingAndTextfield(
            // hintText: currentPage.toString(),
            title: 'Enter ${currentPage == 0 ? 'Report' : 'Template'} Name',
            fontSize: 12.0,
            controller: reportNameController,
          ),
          CustomButton(
            buttonText: 'Create ${currentPage == 0 ? 'Report' : 'Template'}',
            onTap: () {
              if (reportNameController.text.isNotEmpty) {
                Get.back();
                Get.to(
                  () => CustomTaskScreen(
                    reportName: reportNameController.text.trim(),
                    isTemplate: currentPage == 0 ? false : true,
                    isDefault: false,
                  ),
                );
              } else {
                ToastMessage.showToastMessage(
                    message: 'Please Enter Report Name.',
                    backgroundColor: AppColors.blueTextColor);
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}

class CustomTemplatePopup {
  static void show({
    required BuildContext context,
    required MyCustomTask task,
    required CustomTaskController controller,
    required UniversalController universalController,
  }) {
    showCustomPopup(
      context: context,
      width: context.isLandscape ? context.width * 0.4 : context.width * 0.8,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextWidget(
            text:
                'Please select the engine first for which you need to create this report.',
            fontSize: 12.0,
            maxLines: 5,
            fontWeight: FontWeight.w600,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextWidget(
                text: 'Engine Brand',
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                maxLines: 2,
              ),
              IconButton(
                onPressed: () {
                  if (kIsWeb) {
                    // Show popup for web
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Use Mobile App'),
                        content: const Text(
                            'Please use the mobile app to use the QR code scanner.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Navigate to QR code scanner screen for mobile
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ScanQrCodeScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.qr_code),
              ),
            ],
          ),
          Obx(
            () => InkWell(
              onTap: () {
                universalController.engines.isEmpty
                    ? ToastMessage.showToastMessage(
                        message:
                            'Please Add Engines first from the Engine section.',
                        backgroundColor: Colors.red)
                    : null;
              },
              child: CustomDropdown(
                items: universalController.engines,
                hintText: controller.engineBrandName.value != ''
                    ? controller.engineBrandName.value
                    : 'Select Engine Brand',
                onChanged: (value) async {
                  try {
                    final result = await EngineService()
                        .getEngineData(engineName: value?.name ?? '');

                    if (result['success']) {
                      ToastMessage.showToastMessage(
                          message: 'Engine Selected',
                          backgroundColor: Colors.green);
                      final engineData = result['data'];
                      final engineId = engineData['_id'];
                      final engineName = engineData['name'];

                      controller.engineBrandName.value = engineName ?? '';
                      controller.engineBrandId.value = engineId;
                      debugPrint('EngineId: ${controller.engineBrandId.value}');
                      debugPrint(
                          'EngineName: ${controller.engineBrandName.value}');
                    } else {
                      final errorMessage = result['message'];
                      debugPrint('Failed to fetch engine data');
                      debugPrint('ErrorData: ${result['data']}');
                      debugPrint('ErrorMessage: $errorMessage');

                      ToastMessage.showToastMessage(
                          message: errorMessage,
                          backgroundColor: AppColors.blueTextColor);
                    }
                  } catch (e) {
                    debugPrint('An error occurred: $e');
                    ToastMessage.showToastMessage(
                        message: 'An error occurred, please try again',
                        backgroundColor: AppColors.blueTextColor);
                  }
                },
              ),
            ),
          ),
          Obx(
            () => CustomButton(
              usePrimaryColor:
                  controller.engineBrandId.value.isNotEmpty ? true : false,
              buttonText: 'Create New Report',
              fontSize: 12.0,
              onTap: () {
                if (controller.engineBrandName.value.isNotEmpty &&
                    controller.engineBrandId.value.isNotEmpty) {
                  Get.back();
                  Get.to(
                    () => CustomTaskScreen(
                      reportName: task.name,
                      task: task,
                      isTemplate: task.isTemplate,
                      isDefault: task.isDefault,
                    ),
                  );
                } else {
                  ToastMessage.showToastMessage(
                      message: 'Please Select Engine from the Dropdown.',
                      backgroundColor: AppColors.blueTextColor);
                }
              },
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}

void _showDeletePopup(
    {required BuildContext context,
    required CustomTaskController controller,
    required String id}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: AlertDialog(
                  scrollable: true,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    width: context.width * 0.5,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: context.height * 0.02),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(255, 220, 105, 0.4),
                          Color.fromRGBO(86, 127, 255, 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 5.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWidget(
                            text:
                                'Are you sure to delete the Task? This action cannot be undone.',
                            fontSize: 14.0,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400),
                        const SizedBox(height: 12.0),
                        Obx(
                          () => InkWell(
                              onTap: () {
                                controller.deleteCustomTask(taskId: id);
                              },
                              child: ReUsableContainer(
                                verticalPadding: context.height * 0.01,
                                height: 50,
                                color: Colors.red,
                                child: Center(
                                    child: controller.isLoading.value
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SpinKitRing(
                                              lineWidth: 2.0,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const CustomTextWidget(
                                            text: 'Delete',
                                            fontSize: 12,
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          )),
                              )),
                        ),
                        CustomButton(
                          isLoading: false,
                          usePrimaryColor: false,
                          buttonText: 'Cancel',
                          fontSize: 12.0,
                          onTap: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                  ))));
    },
  );
}
