// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mechanix/controllers/auth_controllers.dart';
// import 'package:mechanix/helpers/appcolors.dart';
// import 'package:mechanix/helpers/custom_button.dart';
// import 'package:mechanix/helpers/custom_text.dart';
// import 'package:mechanix/helpers/toast.dart';
// import 'package:mechanix/models/user_model.dart';
// import 'package:mechanix/views/dashboard/dashboard.dart';
//
// class SubscriptionScreen extends StatelessWidget {
//   final AuthController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/images/auth-background.png', fit: BoxFit.cover),
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Column(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         top: context.height * 0.03,
//                         bottom: context.height * 0.03),
//                     child: Image.asset('assets/images/app-logo.png',
//                         height: context.height * 0.08, fit: BoxFit.cover),
//                   ),
//                 ),
//                 Expanded(
//                     child: Container(
//                   padding: EdgeInsets.symmetric(
//                       vertical: context.height * 0.02,
//                       horizontal: context.width * 0.04),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: [
//                         Color.fromRGBO(255, 220, 105, 0.4),
//                         Color.fromRGBO(86, 127, 255, 0.4),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 5.0,
//                         spreadRadius: 5.0,
//                       ),
//                       BoxShadow(
//                         color: Colors.white,
//                         offset: Offset(0.0, 0.0),
//                         blurRadius: 0.0,
//                         spreadRadius: 0.0,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.0),
//                       topRight: Radius.circular(40.0),
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Opacity(
//                           opacity: 0.3,
//                           child: Image.asset(
//                             'assets/images/gear.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CustomTextWidget(
//                             text: 'Subscriptions',
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           CustomTextWidget(
//                             text:
//                                 'Buy Subscriptions according to your business needs',
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.w500,
//                             textAlign: TextAlign.center,
//                             fontStyle: FontStyle.italic,
//                             maxLines: 4,
//                           ),
//                           SizedBox(height: context.height * 0.03),
//                           Obx(
//                             () => Wrap(
//                               children: [
//                                 PlanContainer(
//                                   plan: 'Basic Plan',
//                                   duration: 'Monthly',
//                                   amount: '4.99',
//                                   isSelected:
//                                       controller.selectedSubscription.value ==
//                                           SubscriptionType.basic,
//                                   onSelected:
//                                       controller.setSelectedSubscription,
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.white30, Colors.teal],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 PlanContainer(
//                                   plan: 'Standard Plan',
//                                   duration: 'Quarterly',
//                                   amount: '9.99',
//                                   isSelected:
//                                       controller.selectedSubscription.value ==
//                                           SubscriptionType.standard,
//                                   onSelected:
//                                       controller.setSelectedSubscription,
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.white30, Colors.deepOrange],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 PlanContainer(
//                                   plan: 'Gold Plan',
//                                   duration: 'Bi-Annual',
//                                   amount: '19.99',
//                                   isSelected:
//                                       controller.selectedSubscription.value ==
//                                           SubscriptionType.gold,
//                                   onSelected:
//                                       controller.setSelectedSubscription,
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Colors.white30,
//                                       Colors.deepPurpleAccent
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 PlanContainer(
//                                   plan: 'Premium Plan',
//                                   duration: 'Annually',
//                                   amount: '29.99',
//                                   isSelected:
//                                       controller.selectedSubscription.value ==
//                                           SubscriptionType.premium,
//                                   onSelected:
//                                       controller.setSelectedSubscription,
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.white30, Colors.blueAccent],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16.0),
//                           CustomButton(
//                             buttonText: 'Purchase',
//                             onTap: () {
//                               if (controller.selectedSubscription.value ==
//                                   SubscriptionType.none) {
//                                 ToastMessage.showToastMessage(
//                                     message:
//                                         'Please select the Subscription first.',
//                                     backgroundColor: AppColors.blueTextColor);
//                               } else {
//                                 controller.updateUserSubscription();
//                                 debugPrint(
//                                     'Current SubscriptionType: ${controller.subscriptionType}');
//                                 Get.offAll(
//                                   () => const DashboardScreen(),
//                                   transition: Transition.size,
//                                   duration: const Duration(seconds: 1),
//                                 );
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 8.0),
//                           InkWell(
//                             onTap: () {
//                               controller.subscriptionType =
//                                   SubscriptionType.none;
//                               controller.isSubscriptionPurchased.value = false;
//                               debugPrint(
//                                   'Current SubscriptionType: ${controller.subscriptionType}');
//                               Get.offAll(
//                                 () => const DashboardScreen(),
//                                 transition: Transition.size,
//                                 duration: const Duration(seconds: 1),
//                               );
//                             },
//                             child: CustomTextWidget(
//                               text: 'Skip for now',
//                               fontSize: 12.0,
//                               textAlign: TextAlign.center,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
