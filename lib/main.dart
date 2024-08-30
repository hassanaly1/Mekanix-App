import 'dart:convert';

import 'package:app/helpers/appcolors.dart';
import 'package:app/services/api_endpoints.dart';
import 'package:app/services/token.dart';
import 'package:app/views/auth/login.dart';
import 'package:app/views/auth/onboarding/onboarding.dart';
import 'package:app/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

final GetStorage storage = GetStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Mechanix',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthCheck());
  }
}

class AuthCheck extends StatelessWidget {
  final AuthStatusCheckController authStatusCheckController =
      Get.put(AuthStatusCheckController());

  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authStatusCheckController._initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: AppColors.primaryColor,
            child: Image.asset('assets/images/app-logo.png'),
          ));
        } else {
          if (storage.read('isFirstTime') == true) {
            return const OnBoardingScreen();
          } else if (storage.read('token') != null &&
              authStatusCheckController.isTokenValid.value) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}

class AuthStatusCheckController extends GetxController {
  var isFirstTime = true.obs;
  var isTokenValid = false.obs;
  var isInitialCheckDone = false.obs; // New variable
  final TokenService tokenService = TokenService(); // Instantiate the service

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    isFirstTime.value = tokenService.getToken() == null;
    await checkAuthState();
    isInitialCheckDone.value = true; // Mark initial check as done
  }

  Future<void> checkAuthState() async {
    var authResponse = await postAuthStateChange();
    bool tokenValid = authResponse['statusCode'] == 200;
    isTokenValid.value = tokenValid;
    print('IsTokenValid: ${isTokenValid.value}');

    if (tokenValid) {
      var user = authResponse['user'];
      var token = authResponse['token'];
      tokenService.saveUserInfo(user);
      tokenService.saveToken(token);
      debugPrint('TokenAtStorage: ${tokenService.getToken()}');
      debugPrint('UserAtStorage: ${tokenService.getUserInfo()}');
    } else {
      if (!isFirstTime.value) {
        _showSessionExpiredMessage(); // Show the message only after the initial check
      }
      tokenService.removeToken();
      tokenService.removeUserInfo();
    }
  }

  void _showSessionExpiredMessage() {
    Get.snackbar(
      "Session Expired",
      "Your session has expired. Please log in again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

Future<Map<String, dynamic>> postAuthStateChange() async {
  final TokenService authService = TokenService();
  // var url = Uri.parse(
  //     'https://api.mekanixhub.com/api/auth/onauthstatechange');
  final Uri apiUrl =
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.onAuthStateChangeUrl);
  var token = authService.getToken();
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var response = await http.post(
    apiUrl,
    headers: headers,
  );

  debugPrint('StatusCode: ${response.statusCode} + ${response.reasonPhrase}');
  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    var user = responseBody['user'];
    var token = responseBody['token'];
    var statusCode = response.statusCode;
    return {
      'user': user,
      'token': token,
      'statusCode': statusCode,
    };
  } else if (response.statusCode == 402) {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  } else {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  }
}
