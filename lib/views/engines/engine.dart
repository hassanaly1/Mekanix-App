import 'dart:io';

import 'package:app/controllers/engines_controller.dart';
import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/helpers/reusable_textfield.dart';
import 'package:app/helpers/tabbar.dart';
import 'package:app/helpers/validator.dart';
import 'package:app/models/engine_model.dart';
import 'package:app/views/task/widgets/heading_and_textfield.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EnginesScreen extends StatelessWidget {
  final SideMenuController sideMenu;

  EnginesScreen({super.key, required this.sideMenu});

  final EnginesController controller = Get.put(EnginesController());
  final UniversalController universalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            sideMenu.changePage(0);
            Get.delete<EnginesController>();
            universalController.fetchUserAnalyticsData();
          },
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.02,
                      horizontal: context.width * 0.05),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            context.isLandscape ? context.width * 0.05 : 0.02),
                    child: Column(
                      children: [
                        ReUsableTextField(
                          controller: controller.searchController,
                          hintText: 'Search Engine',
                          suffixIcon: const Icon(Icons.search_sharp),
                          onChanged: (value) {
                            controller.getAllEngines(searchName: value);
                          },
                        ),
                        CustomButton(
                          usePrimaryColor: true,
                          isLoading: false,
                          buttonText: '+ Add Engine',
                          fontSize: 14,
                          onTap: () => _openAddEngineDialog(
                            context: context,
                            controller: controller,
                          ),
                        ),
                        //TabBar
                        CustomTabBar(
                            onTap: (currentPage) {
                              currentPage == 0
                                  ? controller.engineType.value = 'Generator'
                                  : controller.engineType.value = 'Compressor';
                            },
                            title1: 'Generator',
                            title2: 'Compressor'),
                        Expanded(
                          child: Obx(
                            () => TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                EnginesTabbarView(
                                    isGenerator: true,
                                    controller: controller,
                                    engines: universalController.engines
                                        .where((engine) =>
                                            engine.isGenerator == true)
                                        .toList()),
                                EnginesTabbarView(
                                    isGenerator: false,
                                    controller: controller,
                                    engines: universalController.engines
                                        .where((engine) =>
                                            engine.isCompressor == true)
                                        .toList()),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnginesTabbarView extends StatelessWidget {
  const EnginesTabbarView(
      {super.key,
      required this.controller,
      required this.engines,
      required this.isGenerator});

  final EnginesController controller;
  final List<EngineModel> engines;
  final bool isGenerator;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getAllEngines(),
      color: AppColors.primaryColor,
      backgroundColor: AppColors.secondaryColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Obx(
        () => controller.isEnginesAreLoading.value
            ? const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                    heightFactor: 3,
                    child: SpinKitCircle(
                      color: Colors.black87,
                      size: 40.0,
                    )),
              )
            : engines.isEmpty
                ? SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: context.height * 0.15),
                          Image.asset('assets/images/view-task.png',
                              height: context.height * 0.15),
                          CustomTextWidget(
                            text:
                                'No ${isGenerator ? 'Generator' : 'Compressor'} found',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: context.height * 0.25),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        engines.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < engines.length) {
                        final engine = engines[index];
                        return CustomEngineCard(
                          controller: controller,
                          model: engine,
                          onTap: () {},
                        );
                      } else if (controller.isLoading.value) {
                        return const Center(
                          heightFactor: 3,
                          child:
                              SpinKitCircle(color: Colors.black87, size: 40.0),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
      ),
    );
  }
}

void _openAddEngineDialog({
  required BuildContext context,
  required EnginesController controller,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      controller.isQrCodeGenerated.value = false;
                      controller.engineImageUrl.value = '';
                      controller.engineName.clear();
                      controller.engineSubtitle.clear();
                      Get.back();
                    }
                  },
                  child: AlertDialog(
                      scrollable: true,
                      backgroundColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(5),
                      content: Container(
                          width: context.width,
                          height: context.height * 0.7,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: context.height * 0.02),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(255, 220, 105, 0.4),
                                Color.fromRGBO(86, 127, 255, 0.4),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
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
                          child: PageView(
                              controller: controller.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                    child: DialogFirstView(
                                        controller: controller)),
                                SingleChildScrollView(
                                    child: DialogSecondView(
                                        controller: controller)),
                              ]))))));
    },
  );
}

class DialogFirstView extends StatelessWidget {
  final EnginesController controller;

  const DialogFirstView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () => controller.pickImage(),
        child: Obx(
          () => CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            backgroundImage: controller.engineImageUrl.value == ''
                ? const AssetImage('assets/images/placeholder.png')
                    as ImageProvider
                : FileImage(File(controller.engineImageUrl.value)),
          ),
        ),
      ),
      const SizedBox(height: 12.0),
      Form(
          key: controller.engineFormKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            HeadingAndTextfield(
                title: 'Enter Engine Name & Model',
                fontSize: 12.0,
                controller: controller.engineName,
                validator: (val) => AppValidator.validateEmptyText(
                    fieldName: 'Engine Name & Model', value: val)),
            HeadingAndTextfield(
                title: 'Enter Subtitle',
                fontSize: 12.0,
                controller: controller.engineSubtitle,
                validator: (val) => AppValidator.validateEmptyText(
                    fieldName: 'Engine Subtitle', value: val)),
            const CustomTextWidget(
                text: 'Select Engine Type',
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                maxLines: 2),
            Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['Generator', 'Compressor'].map((option) {
                    return Row(children: [
                      Radio(
                          visualDensity: VisualDensity.compact,
                          activeColor: AppColors.blueTextColor,
                          value: option,
                          groupValue: controller.engineType.value,
                          onChanged: (value) {
                            controller.engineType.value = value.toString();
                          }),
                      CustomTextWidget(text: option, fontSize: 11.0)
                    ]);
                  }).toList(),
                ))
          ])),
      Obx(
        () => CustomButton(
            isLoading: controller.isLoading.value,
            usePrimaryColor: controller.isQrCodeGenerated.value == true,
            buttonText: 'Save & Generate QR code',
            fontSize: 12.0,
            onTap: () {
              FormState? formState =
                  controller.engineFormKey.currentState as FormState?;
              if (formState != null && formState.validate()) {
                controller.addEngine();
              }
            }),
      ),
      const Divider(color: Colors.black54),
      const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomTextWidget(
                  text: 'Generate QR Code by filling the above fields.',
                  maxLines: 2,
                  fontSize: 12.0,
                  textAlign: TextAlign.center)))
    ]);
  }
}

class DialogSecondView extends StatelessWidget {
  final EnginesController controller;

  const DialogSecondView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextWidget(
              text: controller.engineName.text,
              maxLines: 2,
              fontSize: 14.0,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: QrImageView(
            data: controller.engineName.text.trim(),
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        // controller.isQrCodeGenerated.value
        //     ? Container(
        //         decoration:
        //             BoxDecoration(border: Border.all(color: Colors.black54)),
        //         child: QrImageView(
        //           data: controller.engineName.text.trim(),
        //           version: QrVersions.auto,
        //           size: 200.0,
        //           // errorStateBuilder: (cxt, err) {
        //           //   return Center(
        //           //     child: CustomTextWidget(
        //           //       text: 'Uh oh! Something went wrong...',
        //           //       textAlign: TextAlign.center,
        //           //       maxLines: 2,
        //           //       fontSize: 12.0,
        //           //     ),
        //           //   );
        //           // },
        //         ),
        //       )
        //     : Center(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: CustomTextWidget(
        //             text:
        //                 'Something went wrong in generating the QrCode, try again!',
        //             maxLines: 2,
        //             fontSize: 10.0,
        //             textAlign: TextAlign.center,
        //           ),
        //         ),
        //       ),
        const Divider(color: Colors.black54),
        CustomButton(
          isLoading: false,
          usePrimaryColor: controller.isQrCodeGenerated.value == true,
          buttonText: 'Close',
          fontSize: 12.0,
          onTap: () {
            controller.isQrCodeGenerated.value = false;
            controller.engineImageUrl.value = '';
            controller.engineName.clear();
            controller.engineSubtitle.clear();
            Get.back();
          },
        ),
      ],
    );
  }
}

class CustomEngineCard extends StatelessWidget {
  final EngineModel model;
  final VoidCallback onTap;
  final EnginesController controller;

  const CustomEngineCard(
      {super.key,
      required this.model,
      required this.onTap,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return ReUsableContainer(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black), shape: BoxShape.circle),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(model.imageUrl ?? ''),
          ),
        ),
        title: CustomTextWidget(
            text: model.name ?? 'No Image Specified',
            fontSize: 14.0,
            fontWeight: FontWeight.w500),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextWidget(
              text: model.subname ?? 'No SubTitle Specified',
              textColor: AppColors.lightTextColor,
              fontSize: 12.0),
          CustomTextWidget(
              text:
                  'Engine Type: ${model.isGenerator == true ? 'Generator' : 'Compressor'}',
              fontSize: 10.0,
              textColor: AppColors.lightGreyColor),
          // CustomTextWidget(
          //     text: model.id ?? 'No Id Specified',
          //     fontSize: 12.0,
          //     textColor: AppColors.lightGreyColor)
        ]),
        trailing: model.isDefault ?? true
            ? null
            : Wrap(
                spacing: 12.0,
                children: [
                  InkWell(
                      onTap: () {
                        _showEditPopup(
                            context: context,
                            controller: controller,
                            model: model);
                      },
                      child: Icon(Icons.edit, color: AppColors.secondaryColor)),
                  InkWell(
                      onTap: () {
                        _showDeletePopup(
                            context: context,
                            controller: controller,
                            model: model);
                      },
                      child: const Icon(Icons.delete, color: Colors.red))
                ],
              ),
        // trailing: QrImageView(
        //     data: model.name ?? '',
        //     version: QrVersions.auto,
        //     // size: context.height * 0.1,
        //     errorStateBuilder: (cxt, err) {
        //       return Center(
        //           child: CustomTextWidget(
        //               text: 'Uh oh! Something went wrong...',
        //               textAlign: TextAlign.center,
        //               maxLines: 2,
        //               fontSize: 12.0));
        //     }),
      ),
    );
  }
}

void _showEditPopup(
    {required BuildContext context,
    required EnginesController controller,
    required EngineModel model}) {
  controller.engineName.text = model.name ?? '';
  controller.engineSubtitle.text = model.subname ?? '';
  controller.engineType.value = model.isGenerator! ? 'Generator' : 'Compressor';
  // RxString engineImageUrl = ''.obs;
  controller.updatedEngineImageUrl.value = model.imageUrl ?? '';
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (!didPop) {
                    controller.isQrCodeGenerated.value = false;
                    controller.engineImageUrl.value = '';
                    controller.engineName.clear();
                    controller.engineSubtitle.clear();
                    controller.engineType.value = 'Generator';
                    Get.back();
                  }
                },
                child: AlertDialog(
                    scrollable: true,
                    backgroundColor: Colors.transparent,
                    content: Container(
                      width: context.width * 0.7,
                      height: context.height * 0.7,
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
                            InkWell(
                              onTap: () => controller.updateImage(model),
                              child: Obx(
                                () => CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  // backgroundImage: model.imageUrl == null
                                  //     ? const AssetImage(
                                  //             'assets/images/placeholder.png')
                                  //         as ImageProvider
                                  //     : NetworkImage(model.imageUrl ?? ''),
                                  backgroundImage: controller
                                              .updatedEngineImageUrl.value ==
                                          ''
                                      ? const AssetImage(
                                              'assets/images/placeholder.png')
                                          as ImageProvider
                                      : NetworkImage(controller
                                          .updatedEngineImageUrl.value),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Form(
                              key: controller.engineFormKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // CustomTextWidget(
                                    //     text: 'ID: ${model.id}',
                                    //     fontSize: 11.0),
                                    HeadingAndTextfield(
                                        title: 'Enter Engine Name & Model',
                                        fontSize: 12.0,
                                        controller: controller.engineName,
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                fieldName:
                                                    'Engine Name & Model',
                                                value: val)),
                                    HeadingAndTextfield(
                                        title: 'Enter Subtitle',
                                        fontSize: 12.0,
                                        controller: controller.engineSubtitle,
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                fieldName: 'Engine Subtitle',
                                                value: val)),
                                    const CustomTextWidget(
                                        text: 'Select Engine Type',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 2),
                                    Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: ['Generator', 'Compressor']
                                            .map((option) {
                                          return Row(children: [
                                            Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                activeColor:
                                                    AppColors.blueTextColor,
                                                value: option,
                                                groupValue:
                                                    controller.engineType.value,
                                                onChanged: (value) {
                                                  controller.engineType.value =
                                                      value.toString();
                                                }),
                                            CustomTextWidget(
                                                text: option, fontSize: 11.0)
                                          ]);
                                        }).toList(),
                                      ),
                                    )
                                  ]),
                            ),
                            Obx(
                              () => CustomButton(
                                  isLoading: controller.isLoading.value,
                                  usePrimaryColor:
                                      controller.isQrCodeGenerated.value ==
                                          true,
                                  buttonText: 'Update',
                                  fontSize: 12.0,
                                  onTap: () {
                                    FormState? formState = controller
                                        .engineFormKey
                                        .currentState as FormState?;
                                    if (formState != null &&
                                        formState.validate()) {
                                      controller.updateEngine(
                                          id: model.id ?? '');
                                    }
                                  }),
                            ),
                          ]),
                    )),
              )));
    },
  );
}

void _showDeletePopup(
    {required BuildContext context,
    required EnginesController controller,
    required EngineModel model}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 200),
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
                    width: context.width,
                    // height: context.height * 0.3,
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
                                'Are you sure to delete the Engine? This action cannot be undone.',
                            fontSize: 14.0,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400),
                        const SizedBox(height: 12.0),
                        Obx(
                          () => InkWell(
                              onTap: () {
                                controller.deleteEngine(engineModel: model);
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
