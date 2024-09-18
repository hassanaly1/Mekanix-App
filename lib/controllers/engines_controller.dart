import 'dart:typed_data';

import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/models/engine_model.dart';
import 'package:app/services/engine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EnginesController extends GetxController {
  var isLoading = false.obs;
  var isEnginesAreLoading = false.obs;
  RxBool isQrCodeGenerated = false.obs;
  XFile? engineImage;
  late Uint8List engineImageInBytes;
  RxString engineImageUrl = ''.obs;
  TextEditingController engineName = TextEditingController();
  TextEditingController engineSubtitle = TextEditingController();
  RxString engineType = 'Generator'.obs;

  RxString updatedEngineImageUrl = ''.obs;

  GlobalKey engineFormKey = GlobalKey<FormState>();
  RxString qrCodeData = ''.obs;

  var fetchedEngines = <EngineModel>[].obs;

  final ImagePicker picker = ImagePicker();
  final PageController pageController = PageController();
  final UniversalController universalController = Get.find();
  EngineService engineService = EngineService();

  //For Pagination
  ScrollController scrollController = ScrollController();
  final RxInt _currentPage = 1.obs;

  //For Searching
  TextEditingController searchController = TextEditingController();

  @override
  onInit() {
    getAllEngines(page: 1);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoading.value) {
          _loadNextPageEngines();
        }
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    pageController.dispose();
    universalController.dispose();
    super.dispose();
  }

  void _loadNextPageEngines() async {
    debugPrint('Loading Next Page ${_currentPage.value} Engines');
    isLoading.value = true;

    List<EngineModel> nextPageEngines = await engineService.getAllEngines(
      page: _currentPage.value,
      token: storage.read('token'),
    );

    // Create a Set of existing engine IDs to avoid duplicates
    Set<String?> existingEngineIds =
        fetchedEngines.map((engine) => engine.id).toSet();

    // Add only unique engines
    for (var engine in nextPageEngines) {
      if (!existingEngineIds.contains(engine.id)) {
        fetchedEngines.add(engine);
        existingEngineIds
            .add(engine.id); // Update the set with the new engine ID
      }
    }

    // Only increment the page if we received a full page of engines
    if (nextPageEngines.length >= 10) {
      _currentPage.value++;
    }

    isLoading.value = false;
  }

  Future<void> getAllEngines({String? searchName, int? page}) async {
    universalController.engines.clear();
    try {
      isEnginesAreLoading.value = true;
      _currentPage.value = 1;
      // Call the service method to fetch the engines
      fetchedEngines.value = await engineService.getAllEngines(
        searchString: searchName ?? '',
        token: storage.read('token'),
        page: page ?? _currentPage.value,
      );
      universalController.engines = fetchedEngines;
      debugPrint('EnginesCount: ${universalController.engines.length}');
    } catch (e) {
      debugPrint('Error fetching engines: $e');
    } finally {
      isEnginesAreLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      engineImage = image;
      engineImageUrl.value = image.path;
      engineImageInBytes = (await engineImage?.readAsBytes())!;

      update();
    }
  }

  Future<void> updateImage(EngineModel model) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      engineImage = image;
      engineImageUrl.value = image.path;
      engineImageInBytes = (await engineImage?.readAsBytes())!;
      print('EngineImageInBytes: $engineImageInBytes');
      String updatedImageUrl = await engineService.updateEngineImage(
          engineImageInBytes: engineImageInBytes,
          engineId: model.id ?? '',
          token: storage.read('token'));
      if (updatedImageUrl != '') {
        ToastMessage.showToastMessage(
            message: 'Engine Image Updated Successfully',
            backgroundColor: Colors.green);
        model.imageUrl = updatedImageUrl;
        // engineImageUrl.value = model.imageUrl ?? '';
        updatedEngineImageUrl.value = model.imageUrl ?? '';
        update();
      }
    }
  }

  void addEngine() async {
    if (engineImageUrl.value == '') {
      ToastMessage.showToastMessage(
          message: 'Please Select an Engine Image',
          backgroundColor: Colors.red);
    } else {
      isLoading.value = true;
      try {
        var newEngine = EngineModel(
          userId: storage.read('user_info')['_id'],
          name: engineName.text.trim(),
          imageUrl: engineImageUrl.value,
          subname: engineSubtitle.text.trim(),
          isGenerator: engineType.value == 'Generator',
          isCompressor: engineType.value == 'Compressor',
          isDefault: false,
        );
        bool success = await engineService.addEngine(
            engineModel: newEngine, engineImageInBytes: engineImageInBytes);

        if (success) {
          ToastMessage.showToastMessage(
              message: 'Engine Added Successfully',
              backgroundColor: Colors.green);
          isLoading.value = false;
          pageController.nextPage(
              duration: const Duration(milliseconds: 300), curve: Curves.ease);

          isQrCodeGenerated.value = true;
          engineType.value = 'Generator';
          getAllEngines();
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, please try again',
              backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateEngine({required String id}) async {
    isLoading.value = true;
    try {
      var updatedEngineData = EngineModel(
        id: id,
        userId: storage.read('user_info')['_id'],
        name: engineName.text.trim(),
        subname: engineSubtitle.text.trim(),
        isGenerator: engineType.value == 'Generator',
        isCompressor: engineType.value == 'Compressor',
        isDefault: false,
      );
      bool success = await engineService.updateEngine(
          engineModel: updatedEngineData, token: storage.read('token'));
      isLoading.value = false;
      if (success) {
        ToastMessage.showToastMessage(
            message: 'Engine Updated Successfully',
            backgroundColor: Colors.green);
        getAllEngines();
        Get.back();
      } else {
        ToastMessage.showToastMessage(
            message: 'Failed to update engine, please try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      debugPrint('Error updating engine: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> deleteEngine({required EngineModel engineModel}) async {
    debugPrint('DeleteEngineFunctionCalled');

    try {
      isLoading.value = true;
      var deletedEngineData = EngineModel(
        id: engineModel.id,
        userId: storage.read('user_info')['_id'],
        name: engineModel.name,
        subname: engineModel.subname,
        isGenerator: engineModel.isGenerator,
        isCompressor: engineModel.isCompressor,
        isDefault: false,
      );
      bool success = await engineService.deleteEngine(
        engineModel: deletedEngineData,
        token: storage.read('token'),
      );

      if (success) {
        ToastMessage.showToastMessage(
          message: 'Engine Deleted Successfully',
          backgroundColor: Colors.green,
        );
        getAllEngines();
        Get.back();
      } else {
        ToastMessage.showToastMessage(
          message: 'Failed to delete engine, please try again',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      ToastMessage.showToastMessage(
        message: 'Something went wrong, please try again',
        backgroundColor: Colors.red,
      );
      debugPrint('Error deleting engine: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    engineName.clear();
    engineSubtitle.clear();
    engineImageUrl.value = '';
    engineImageInBytes = Uint8List(0);
    isQrCodeGenerated.value = false;
    pageController.dispose();
    super.onClose();
  }
}
