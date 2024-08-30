// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mechanix/controllers/auth_controllers.dart';
// import 'package:mechanix/helpers/custom_button.dart';
// import 'package:mechanix/views/auth/login.dart';
// import 'package:mechanix/views/auth/login_web.dart';
// import 'package:mechanix/views/auth/signup_web.dart';
// import 'package:mechanix/views/auth/signup.dart';
//
// class StartScreen extends StatelessWidget {
//   StartScreen({super.key});
//
//   final AuthController controller = Get.put(AuthController());
//
//   @override
//   Widget build(BuildContext context) {
//     return context.width < 900
//         ? RightSideView()
//         : Row(
//             children: [
//               Obx(
//                 () => Expanded(
//                   flex: 3,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: context.height * 0.05,
//                         horizontal: context.width * 0.15),
//                     decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                           colors: [
//                             Color.fromRGBO(255, 220, 105, 0.4),
//                             Color.fromRGBO(86, 127, 255, 0.4),
//                           ],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 5.0,
//                             spreadRadius: 5.0,
//                           ),
//                           BoxShadow(
//                             color: Colors.white,
//                             offset: Offset(0.0, 0.0),
//                             blurRadius: 0.0,
//                             spreadRadius: 0.0,
//                           ),
//                         ]),
//                     child: controller.isLoginScreen.value
//                         ? LoginScreenWeb(controller: controller)
//                         : SignupScreenWeb(controller: controller),
//                   ),
//                 ),
//               ),
//               Expanded(flex: 2, child: RightSideView()),
//             ],
//           );
//   }
// }
//
// class RightSideView extends StatelessWidget {
//   RightSideView({
//     super.key,
//   });
//   final AuthController controller = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: context.height * 0.05,
//                 horizontal: context.height * 0.05),
//             child: Container(
//               height: context.height,
//               padding: EdgeInsets.symmetric(
//                   vertical: context.height * 0.05,
//                   horizontal: context.width * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.0),
//                   image: const DecorationImage(
//                     image: AssetImage(
//                       'assets/images/background_shadow.png',
//                     ),
//                     fit: BoxFit.cover,
//                   )),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: context.height * 0.1),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: context.height * 0.05),
//                       child: Image.asset(
//                         'assets/images/app-logo.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(height: context.height * 0.2),
//                     CustomButton(
//                       buttonText: 'Login',
//                       onTap: () {
//                         context.width > 900
//                             ? controller.isLoginScreen.value = true
//                             : Get.to(() => LoginScreen());
//                       },
//                     ),
//                     CustomButton(
//                         buttonText: 'Register',
//                         onTap: () {
//                           context.width > 900
//                               ? controller.isLoginScreen.value = false
//                               : Get.to(() => SignupScreen());
//                         },
//                         usePrimaryColor: true),
//                     SizedBox(height: context.height * 0.1),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
