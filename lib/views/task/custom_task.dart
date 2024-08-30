import 'dart:io';
import 'dart:typed_data';

import 'package:app/controllers/custom_task_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/helpers/reusable_textfield.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/helpers/validator.dart';
import 'package:app/models/custom_task_model.dart';
import 'package:app/services/task_service.dart';
import 'package:app/views/task/widgets/checkbox.dart';
import 'package:app/views/task/widgets/heading.dart';
import 'package:app/views/task/widgets/heading_and_textfield.dart';
import 'package:app/views/task/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyAttachmentModel {
  final String name, path;

  MyAttachmentModel({
    required this.name,
    required this.path,
  });
}

class CustomTaskScreen extends StatefulWidget {
  final bool isTemplate;
  final bool isDefault;
  final String reportName;
  final MyCustomTask? task;

  const CustomTaskScreen({
    super.key,
    this.task,
    required this.isTemplate,
    required this.reportName,
    required this.isDefault,
  });

  @override
  State<CustomTaskScreen> createState() => _CustomTaskScreenState();
}

class _CustomTaskScreenState extends State<CustomTaskScreen> {
  late Rx<MyCustomTask> _task;
  final _isForm = true.obs;
  final _isTemplate = false.obs;
  final _attachments = <Uint8List>[];
  final _hintTextController = TextEditingController();
  final _radioController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validateEmail = GlobalKey<FormState>();

  final PageController _pageController = PageController();
  final _currentPage = 0.obs;

  final isLoading = false.obs, listOfAttachments = <MyAttachmentModel>[].obs;

  @override
  void initState() {
    _task = Rx<MyCustomTask>(widget.task ??
        MyCustomTask(
            name: widget.reportName,
            customerName: _customerNameController.text.trim(),
            customerEmail: _customerEmailController.text.trim(),
            pages: <MyPage>[MyPage(sections: [])],
            isForm: _isForm.value,
            isTemplate: widget.isTemplate,
            isDefault: widget.isDefault));
    super.initState();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _hintTextController.dispose();
    _radioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/home-bg.png', fit: BoxFit.fill),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.red,
                  forceMaterialTransparency: true,
                  expandedHeight: context.height * 0.1,
                  flexibleSpace: Center(
                    child: CustomTextWidget(
                      text: widget.reportName,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
              body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      _buildHeader(context),
                      _task.value.pages[0].sections.isEmpty
                          ? const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'No Items Added, Tap on ',
                                    style: TextStyle(
                                        fontSize: 14.0, fontFamily: 'Poppins'),
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.more_vert,
                                        size: 14.0, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: ' icon to add Pages.',
                                    style: TextStyle(
                                        fontSize: 14.0, fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            )
                          : Expanded(
                              child: Obx(
                                () => PageView(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (value) {
                                    _currentPage.value = value;
                                  },
                                  children: _task.value.pages
                                      .map((e) => Container(
                                            child: _buildFormSectionsList(
                                                currentPage:
                                                    _currentPage.value),
                                          ))
                                      .toList(),
                                ),
                              ),
                            )

                      // : Expanded(child: _buildFormSectionsList()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ReUsableContainer(
          color: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_currentPage.value > 0) {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  } else {
                    Get.back();
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              SizedBox(
                width: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      text:
                          'Page: ${_currentPage.value + 1}/${_task.value.pages.length}',
                      fontSize: 14.0,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8.0),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _task.value.pages.length,
                        axisDirection: Axis.horizontal,
                        effect: SlideEffect(
                          spacing: 8.0,
                          radius: 4.0,
                          dotWidth: 16.0,
                          dotHeight: 4.0,
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.black45,
                          activeDotColor: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!_task.value.isDefault)
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 1) {
                      if (_task.value.pages[_task.value.pages.length - 1]
                          .sections.isNotEmpty) {
                        _task.value.pages.add(MyPage(sections: []));
                        _task.refresh();
                      } else {
                        ToastMessage.showToastMessage(
                            message:
                                'Please Add at least one section in the current page.',
                            backgroundColor: Colors.red);
                      }
                    } else if (value == 2) {
                      if (_currentPage.value != 0) {
                        debugPrint('Removing Page: ${_currentPage.value}');
                        // _task.value.pages.removeLast();
                        _task.value.pages.removeAt(_currentPage.value);
                        _pageController
                            .jumpToPage(_task.value.pages.length - 1);
                        _task.refresh();
                      }
                    } else {
                      showAddSectionPopup(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.chrome_reader_mode),
                          SizedBox(width: 10),
                          CustomTextWidget(
                              text: "Add Page", textColor: Colors.black)
                        ],
                      ),
                    ),
                    if (_currentPage.value != 0)
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.list),
                            SizedBox(width: 10),
                            CustomTextWidget(
                                text: "Remove Page", textColor: Colors.black)
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(width: 10),
                          CustomTextWidget(
                              text: "Add Section", textColor: Colors.black)
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                )
              else
                const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.more_vert_sharp,
                      color: Colors.transparent,
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionsList({required int currentPage}) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _task.value.pages[currentPage].sections.length,
              itemBuilder: (context, index) {
                final section = _task.value.pages[currentPage].sections[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ReUsableContainer(
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        ContainerHeading(
                          heading: section.heading,
                          showIcons: _task.value.isDefault ? false : true,
                          onAdd: () {
                            _hintTextController.clear();
                            showAddElementPopup(context, sectionIndex: index);
                          },
                          onDelete: () {
                            _task.value.pages[currentPage].sections
                                .removeAt(index);
                            _task.refresh();
                          },
                        ),
                        _buildSectionElements(
                          index,
                          currentPage,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        _task.value.pages.length == 1
            ? SaveAndSubmitButton()
            : _currentPage.value == 0
                ? NextButton(pageController: _pageController)
                : _currentPage.value == _task.value.pages.length - 1
                    ? SaveAndSubmitButton()
                    : BackAndNextButton(pageController: _pageController),
      ],
    );
  }

  Column SaveAndSubmitButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.isTemplate
              ? false
              : _task.value.pages[0].sections.isEmpty
                  ? false
                  : true && widget.task == null,
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.blueTextColor,
            controlAffinity: ListTileControlAffinity.leading,
            title: const CustomTextWidget(
              text: 'Save as template for future use',
              fontSize: 12.0,
            ),
            value: _isTemplate.value,
            onChanged: (value) {
              _isTemplate.value = !_isTemplate.value;
              _task.value.isTemplate = _isTemplate.value;
            },
          ),
        ),
        Obx(
          () => Row(
            children: [
              if (_task.value.isTemplate == true && _task.value.isForm == false)
                Flexible(
                  // Send Report Button when Coming from Already Created Template
                  // _task.value.isTemplate = false;
                  // _task.value.isForm = true;
                  child: CustomButton(
                    isLoading: false,
                    usePrimaryColor: true,
                    buttonText: 'Send Report',
                    onTap: () {
                      showCustomPopup(
                        context: context,
                        width: context.width * 0.6,
                        widget: Form(
                          key: _validateEmail,
                          child: Column(
                            children: [
                              const CustomTextWidget(
                                text:
                                    'Enter the name of the Customer you want to send this task as report via emails.',
                                fontSize: 10.0,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                              HeadingAndTextfield(
                                title: 'Enter Customer Name',
                                controller: _customerNameController,
                                hintText: 'Customer Name',
                                validator: (val) =>
                                    AppValidator.validateEmptyText(
                                        value: val, fieldName: 'Customer Name'),
                              ),
                              HeadingAndTextfield(
                                title: 'Enter Customer Email',
                                controller: _customerEmailController,
                                hintText: 'Customer Email',
                                validator: (val) =>
                                    AppValidator.validateEmail(value: val),
                              ),
                              Obx(
                                () => CustomButton(
                                  buttonText: 'Send Report',
                                  usePrimaryColor: true,
                                  onTap: () {
                                    if (_validateEmail.currentState!
                                        .validate()) {
                                      if (_customerNameController
                                              .text.isNotEmpty &&
                                          _customerEmailController
                                              .text.isNotEmpty) {
                                        _task.value.isTemplate = false;
                                        _task.value.isForm = true;

                                        _task.value.customerName =
                                            _customerNameController.text.trim();
                                        _task.value.customerEmail =
                                            _customerEmailController.text
                                                .trim();
                                        print(
                                            'Customer Name: ${_task.value.customerName}');
                                        print(
                                            'Customer Email: ${_task.value.customerEmail}');
                                        onSubmitTask(_task.value, _attachments);
                                      } else {
                                        ToastMessage.showToastMessage(
                                            message:
                                                'Please Enter Customer Name and Email',
                                            backgroundColor: Colors.red);
                                      }
                                    }
                                  },
                                  isLoading: isLoading.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                //BackButton
                Visibility(
                  visible: _currentPage.value != 0,
                  child: Flexible(
                    child: CustomButton(
                      usePrimaryColor: true,
                      onTap: () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic);
                      },
                      buttonText: 'Back',
                      isLoading: false,
                    ),
                  ),
                ),
              Visibility(
                visible: _task.value.isDefault
                    ? false
                    : _task.value.pages[0].sections.isEmpty
                        ? false
                        : true,
                child: Flexible(
                  child: CustomButton(
                    isLoading: isLoading.value,
                    buttonText: widget.task == null
                        ? widget.isTemplate
                            ? 'Add Template'
                            : 'Submit Task'
                        : 'The Update',
                    onTap: () {
                      if (widget.task == null) {
                        if (widget.isTemplate) {
                          // Add Template
                          onSubmitTask(_task.value, _attachments,
                              isTemplate: true);
                        } else {
                          // Submit Newly Created Task

                          showCustomPopup(
                            context: context,
                            width: context.width * 0.6,
                            widget: Form(
                              key: _validateEmail,
                              child: Column(
                                children: [
                                  const CustomTextWidget(
                                    text:
                                        'Enter the name of the Customer you want to send this task as report via emails.',
                                    fontSize: 10.0,
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                  ),
                                  HeadingAndTextfield(
                                    title: 'Enter Customer Name',
                                    controller: _customerNameController,
                                    hintText: 'Customer Name',
                                    validator: (val) =>
                                        AppValidator.validateEmptyText(
                                            value: val,
                                            fieldName: 'Customer Name'),
                                  ),
                                  HeadingAndTextfield(
                                    title: 'Enter Customer Email',
                                    controller: _customerEmailController,
                                    hintText: 'Customer Email',
                                    validator: (val) =>
                                        AppValidator.validateEmail(value: val),
                                  ),
                                  // HeadingAndTextfield(
                                  //   title: 'Enter Customer Name',
                                  //   controller: _customerNameController,
                                  //   hintText: 'Customer Name',
                                  //   validator: (p0) {
                                  //     AppValidator.validateEmptyText(
                                  //       fieldName: 'Customer Name',
                                  //       value: p0,
                                  //     );
                                  //     return null;
                                  //   },
                                  // ),
                                  // HeadingAndTextfield(
                                  //   title: 'Enter Customer Email',
                                  //   controller: _customerEmailController,
                                  //   hintText: 'Customer Email',
                                  //   validator: (p0) {
                                  //     AppValidator.validateEmptyText(
                                  //       fieldName: 'Customer Email',
                                  //       value: p0,
                                  //     );
                                  //     return null;
                                  //   },
                                  // ),
                                  Obx(
                                    () => CustomButton(
                                      buttonText: 'Send Report',
                                      onTap: () {
                                        if (_validateEmail.currentState!
                                            .validate()) {
                                          if (_customerNameController
                                                  .text.isNotEmpty &&
                                              _customerEmailController
                                                  .text.isNotEmpty) {
                                            print(_task.value.isTemplate);
                                            print(_task.value.isForm);
                                            debugPrint('SubmittingTask');
                                            _task.value.customerName =
                                                _customerNameController.text
                                                    .trim();
                                            _task.value.customerEmail =
                                                _customerEmailController.text
                                                    .trim();
                                            // print(
                                            //     'Customer Name: ${_task.value.customerName}');
                                            // print(
                                            //     'Customer Email: ${_task.value.customerEmail}');
                                            onSubmitTask(
                                                _task.value, _attachments);
                                          } else {
                                            ToastMessage.showToastMessage(
                                                message:
                                                    'Please Enter Customer Name and Email',
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                      },
                                      isLoading: isLoading.value,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        debugPrint('UpdatingTask');
                        print('Updating Task: ${_task.value.toMap()}');
                        onUpdateTask(
                          _task.value,
                          _attachments,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionElements(
    int sectionIndex,
    int currentPage,
  ) {
    return Obx(
      () => Column(
        children: _task.value.pages[currentPage].sections[sectionIndex].elements
            .map((element) {
          switch (element.type) {
            case MyCustomItemType.textfield:
              return HeadingAndTextfield(
                showDeleteIcon: _task.value.isDefault ? false : true,
                title: element.label ?? '',
                controller: TextEditingController(text: element.value),
                onChanged: (String? value) => element.value = value ?? '',
                onDelete: () {
                  _task.value.pages[currentPage].sections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.textarea:
              return HeadingAndTextfield(
                maxLines: 5,
                showDeleteIcon: _task.value.isDefault ? false : true,
                title: element.label ?? '',
                controller: TextEditingController(text: element.value),
                onChanged: (String? value) => element.value = value ?? '',
                onDelete: () {
                  _task.value.pages[currentPage].sections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.radiobutton:
              return CustomRadioButton(
                options: element.options ?? [],
                selected: element.value,
                heading: element.label ?? '',
                showDeleteIcon: _task.value.isDefault ? false : true,
                onChange: (String value) => element.value = value,
                onDelete: () {
                  _task.value.pages[currentPage].sections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.checkbox:
              List<String> selectedValues;
              if (element.value is List<dynamic>) {
                selectedValues = (element.value as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();
              } else {
                selectedValues = [];
              }
              return CustomCheckboxWidget(
                options: element.options ?? [],
                heading: element.label ?? '',
                selected: selectedValues,
                // selected: element.value.cast<String>() ?? [],
                // selected: element.value?.cast<String>() ?? [],
                // (element.value != null &&
                //     element.value is String &&
                //     element.value.isNotEmpty)
                //     ?
                onChange: (List<String> values) => element.value = values,
                showDeleteIcon: _task.value.isDefault ? false : true,
                onDelete: () {
                  _task.value.pages[currentPage].sections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.attachment:
              MyAttachmentModel? attach;
              if (element.value is int) {
                attach = listOfAttachments[element.value];
              }
              return Obx(
                () => HeadingAndTextfield(
                  title: element.label ?? '',
                  hintText: widget.task == null
                      ? attach == null
                          ? 'No file selected'
                          : attach.name
                      : element.value.toString(),
                  // : listOfAttachments[element.value].name,
                  readOnly: listOfAttachments.isEmpty ? true : true,
                  onTap: () async {
                    int? oldIndex;
                    if (attach != null) {
                      final List<MyCustomElementModel> elements = _task.value
                          .pages[currentPage].sections[sectionIndex].elements;
                      oldIndex = elements.indexOf(element);
                    }
                    XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      String fileExtension =
                          image.name.split('.').last.toLowerCase();
                      if (fileExtension == 'png' ||
                          fileExtension == 'jpeg' ||
                          fileExtension == 'jpg') {
                        Uint8List imageBytes = await image.readAsBytes();
                        if (oldIndex != null) {
                          _attachments[oldIndex] = imageBytes;
                        } else {
                          int i = _attachments.length;
                          _attachments.insert(i, imageBytes);
                          element.value = i;
                          listOfAttachments.add(
                            MyAttachmentModel(
                              name: image.name,
                              path: image.path,
                            ),
                          );
                          _task.refresh();
                        }
                      } else {
                        Get.snackbar(
                            'Error.', 'Please select a PNG or JPEG file.');
                      }
                    }
                  },
                  showDeleteIcon: true,
                  onDelete: () {
                    _task.value.pages[currentPage].sections[sectionIndex]
                        .elements
                        .remove(element);
                    _task.refresh();
                  },
                  showEyeIcon: widget.task == null
                      ? attach != null
                      : element.value != '',
                  onEyeTap: () {
                    if (widget.task == null
                        ? attach != null
                        : element.value != '') {
                      Get.dialog(
                        Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 4.0),
                              const Text(
                                'Attachment',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              AspectRatio(
                                  aspectRatio: 1,
                                  child: widget.task != null
                                      ? Image.network(
                                          element.value,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        )
                                      : Image.file(File(attach!.path))),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            default:
              return Container();
          }
        }).toList(),
      ),
    );
  }

  void showAddSectionPopup(BuildContext context) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: ReUsableTextField(
                hintText: 'Enter Section Name',
                controller: _hintTextController,
                validator: (value) => AppValidator.validateEmptyText(
                    fieldName: 'Section Name', value: value),
              ),
            ),
            CustomButton(
              usePrimaryColor: true,
              buttonText: 'Add Section',
              onTap: () {
                if (_hintTextController.text.isNotEmpty) {
                  MySection newSection = MySection(
                    heading: _hintTextController.text,
                    elements: [],
                  );
                  _task.value.pages[_currentPage.value].sections
                      .add(newSection);
                  _hintTextController.clear();
                  _task.refresh();
                  Get.back();
                } else {
                  ToastMessage.showToastMessage(
                      message: 'Please Add Section Heading',
                      backgroundColor: Colors.red);
                }
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  void showAddElementPopup(BuildContext context, {required int sectionIndex}) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAddTextFieldButton(context, sectionIndex: sectionIndex),
            _buildAddTextFieldButton(context,
                isTextArea: true, sectionIndex: sectionIndex),
            _buildAddCheckboxAndRadioButton(context,
                sectionIndex: sectionIndex, isCheckbox: false),
            _buildAddCheckboxAndRadioButton(context,
                sectionIndex: sectionIndex, isCheckbox: true),
            _buildAddAttachmentButton(context, sectionIndex: sectionIndex),
            // _buildAddGridButton(context, sectionIndex: sectionIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTextFieldButton(BuildContext context,
      {bool isTextArea = false, required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: isTextArea ? 'Add Textarea' : 'Add Textfield',
      onTap: () {
        Get.back();
        showCustomPopup(
          context: context,
          width: context.width * 0.3,
          widget: Column(
            children: [
              Form(
                key: _formKey,
                child: ReUsableTextField(
                  hintText: 'Enter Textfield Name',
                  controller: _hintTextController,
                  validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Textfield Name', value: value),
                ),
              ),
              CustomButton(
                usePrimaryColor: true,
                buttonText: 'Add Textfield',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    MyCustomElementModel myCustomItemModel =
                        MyCustomElementModel(
                      label: _hintTextController.text,
                      type: isTextArea
                          ? MyCustomItemType.textarea
                          : MyCustomItemType.textfield,
                      value: '',
                    );
                    _task.value.pages[_currentPage.value].sections[sectionIndex]
                        .elements
                        .add(myCustomItemModel);
                    _task.refresh();
                    Get.back();
                    _hintTextController.clear();
                  }
                },
                isLoading: false,
              ),
            ],
          ),
        );
      },
      isLoading: false,
    );
  }

  Widget _buildAddCheckboxAndRadioButton(BuildContext context,
      {required bool isCheckbox, required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: isCheckbox ? 'Add Checkbox' : 'Add Radio Button',
      onTap: () {
        Get.back();
        _showRadioButtonPopup(context,
            isCheckbox: isCheckbox, sectionIndex: sectionIndex);
      },
      isLoading: false,
    );
  }

  Widget _buildAddAttachmentButton(BuildContext context,
      {required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: 'Add Attachment',
      onTap: () {
        Get.back();
        showCustomPopup(
          context: context,
          width: context.width * 0.3,
          widget: Column(
            children: [
              Form(
                key: _formKey,
                child: ReUsableTextField(
                  hintText: 'Enter Heading',
                  controller: _hintTextController,
                  validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Heading', value: value),
                ),
              ),
              CustomButton(
                usePrimaryColor: true,
                buttonText: 'Add Attachments',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    MyCustomElementModel myCustomItemModel =
                        MyCustomElementModel(
                      label: _hintTextController.text,
                      type: MyCustomItemType.attachment,
                      value: null,
                    );
                    _task.value.pages[_currentPage.value].sections[sectionIndex]
                        .elements
                        .add(myCustomItemModel);
                    Get.back();
                    _hintTextController.clear();
                  }
                },
                isLoading: false,
              ),
            ],
          ),
        );
      },
      isLoading: false,
    );
  }

  void _showRadioButtonPopup(BuildContext context,
      {bool isCheckbox = false, required int sectionIndex}) {
    var options = <String>[].obs;
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                ReUsableTextField(
                  hintText: 'Enter Heading',
                  controller: _hintTextController,
                  validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Heading', value: value),
                ),
                ReUsableTextField(
                  hintText: 'Enter Option',
                  controller: _radioController,
                ),
                Obx(
                  () => Wrap(
                    children: options
                        .map(
                          (option) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              backgroundColor: AppColors.blueTextColor,
                              deleteIconColor: Colors.red,
                              deleteIcon: const Icon(Icons.clear, size: 20),
                              padding: const EdgeInsets.all(8.0),
                              onDeleted: () {
                                options.remove(option);
                                _task.refresh();
                              },
                              label: CustomTextWidget(
                                  text: option, textColor: Colors.white70),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_radioController.text.isNotEmpty) {
                      options.add(_radioController.text.trim());
                      _radioController.clear();
                    }
                  },
                  child: const CustomTextWidget(
                    text: 'Add Option',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            usePrimaryColor: true,
            buttonText: isCheckbox ? 'Add Checkbox' : 'Add Radio Button',
            onTap: () {
              if (_formKey.currentState!.validate() &&
                  options.isNotEmpty &&
                  options.length > 1) {
                MyCustomElementModel myCustomItemModel = MyCustomElementModel(
                  label: _hintTextController.text,
                  type: isCheckbox
                      ? MyCustomItemType.checkbox
                      : MyCustomItemType.radiobutton,
                  options: options,
                  value: isCheckbox ? <String>[] : '',
                );
                _task.value.pages[_currentPage.value].sections[sectionIndex]
                    .elements
                    .add(myCustomItemModel);
                _task.refresh();
                Get.back();
                _hintTextController.clear();
              } else {
                ToastMessage.showToastMessage(
                    message: 'Please add atleast 2 options',
                    backgroundColor: Colors.red);
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }

  onSubmitTask(MyCustomTask e, List<Uint8List> attachments,
      {bool isTemplate = false}) async {
    debugPrint('SubmittingTask');
    print('IsTemplateValue: ${e.isTemplate}');
    print('IsFormValue: ${e.isForm}');

    // if (isTemplate) {
    //   e.isTemplate = true;
    //   e.isForm = false;
    // }
    // print('IsTemplateValueAfterChange: ${e.isTemplate}');
    // print('IsFormValueAfterChange: ${e.isForm}');
    try {
      isLoading(true);
      final urls = <String>[];
      TaskResponse response =
          await TaskService().addCustomTaskFiles(attachments: attachments);
      if (response.isSuccess) {
        print(response.data);
        urls.assignAll(response.data);
        for (MySection section in e.pages[_currentPage.value].sections) {
          for (MyCustomElementModel element in section.elements) {
            if (element.type == MyCustomItemType.attachment &&
                element.value is int) {
              element.value = urls[element.value];
            }
          }
        }
        // print('IS_TEMPLATE: $isTemplate');
        // print('IsTemplateValue: ${e.isTemplate}');
        // print('IsFormValue: ${e.isForm}');
        // if (isTemplate) {
        //   e.isTemplate = true;
        //   e.isForm = false;
        // }
        // print('IsTemplateValueAfterChange: ${e.isTemplate}');
        // print('IsFormValueAfterChange: ${e.isForm}');
        bool isSuccess = false;
        if (isTemplate) {
          isSuccess =
              await TaskService().createCustomTemplate(taskData: e.toMap());
        } else {
          isSuccess = await TaskService().createCustomTask(taskData: e.toMap());
        }

        if (isSuccess) {
          ToastMessage.showToastMessage(
              message: isTemplate
                  ? 'Template Created Successfully'
                  : 'Task Created Successfully',
              backgroundColor: Colors.green);

          final CustomTaskController controller = Get.find();
          controller.getAllCustomTasks(page: 1);
          controller.getAllCustomTasks(page: 1, isTemplate: true);
          Get.back();
          Get.back();
        }
      } else {
        print("Error in onSubmitTask");
        ToastMessage.showToastMessage(
            message: 'Failed to create task, please try again',
            backgroundColor: Colors.red);
        urls.clear();
      }
    } catch (e) {
      print("Error in onSubmitTask: $e");
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  onUpdateTask(MyCustomTask e, List<Uint8List> attachments) async {
    try {
      isLoading(true);
      final urls = <String>[];
      TaskResponse response =
          await TaskService().addCustomTaskFiles(attachments: attachments);
      if (response.isSuccess) {
        urls.assignAll(response.data);
        print(urls);

        for (MySection section in e.pages[_currentPage.value].sections) {
          for (MyCustomElementModel element in section.elements) {
            if (element.type == MyCustomItemType.attachment &&
                element.value is int) {
              element.value = urls[element.value];
            }
          }
        }
        final isSuccess = await TaskService()
            .updateCustomTask(taskData: e.toMap(), taskId: e.id ?? '');
        if (isSuccess) {
          ToastMessage.showToastMessage(
              message: 'Task Updated Successfully',
              backgroundColor: Colors.green);
          final CustomTaskController controller = Get.find();
          controller.getAllCustomTasks();
          Get.back();
        }
      } else {
        print("Error in onUpdateTask");
        ToastMessage.showToastMessage(
            message: 'Failed to update task, please try again',
            backgroundColor: Colors.red);
        urls.clear();
      }
    } catch (e) {
      print("Error in onUpdateTask: $e");
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic);
      },
      buttonText: 'Next',
      isLoading: false,
    );
  }
}

class BackAndNextButton extends StatelessWidget {
  const BackAndNextButton({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: CustomButton(
            onTap: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic);
            },
            buttonText: 'Back',
            isLoading: false,
            usePrimaryColor: true,
          ),
        ),
        Flexible(
          child: CustomButton(
            onTap: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic);
            },
            buttonText: 'Next',
            isLoading: false,
          ),
        ),
      ],
    );
  }
}

void showCustomPopup(
    {required BuildContext context,
    required double? width,
    required Widget widget}) {
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
                    width: width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: context.height * 0.05),
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
                    child: widget,
                  ))));
    },
  );
}
