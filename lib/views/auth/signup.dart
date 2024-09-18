import 'package:app/controllers/auth_controllers.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_textfield.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/helpers/validator.dart';
import 'package:app/views/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController controller = Get.find();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/auth-background.png', fit: BoxFit.cover),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: context.height * 0.05,
                          bottom: context.height * 0.05),
                      child: Image.asset('assets/images/app-logo.png',
                          height: context.height * 0.12, fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: context.height * 0.02,
                        horizontal: context.width * 0.02),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/images/gear.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.width > 700
                                  ? context.width * 0.2
                                  : context.width * 0.1),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomTextWidget(
                                  text: 'Register Account',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                const CustomTextWidget(
                                  text:
                                      'Fill the Details to register your account',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                  fontStyle: FontStyle.italic,
                                  maxLines: 4,
                                ),
                                Form(
                                  key: _signupFormKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: context.height * 0.03),
                                      ReUsableTextField(
                                        controller: controller.fNameController,
                                        hintText: 'First Name',
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                          color: AppColors.primaryColor,
                                        ),
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                value: val,
                                                fieldName: 'First Name'),
                                      ),
                                      ReUsableTextField(
                                        controller: controller.lNameController,
                                        hintText: 'Last Name',
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                          color: AppColors.primaryColor,
                                        ),
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                value: val,
                                                fieldName: 'Last Name'),
                                      ),
                                      ReUsableTextField(
                                        controller: controller.emailController,
                                        hintText: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: AppColors.primaryColor,
                                        ),
                                        validator: (val) =>
                                            AppValidator.validateEmail(
                                                value: val),
                                      ),
                                      Obx(
                                        () => ReUsableTextField(
                                          controller:
                                              controller.passwordController,
                                          hintText: 'Password',
                                          prefixIcon: Icon(
                                            Icons.lock_open_rounded,
                                            color: AppColors.primaryColor,
                                          ),
                                          obscureText:
                                              controller.showPassword.value,
                                          suffixIcon: IconButton(
                                            onPressed: () => controller
                                                    .showPassword.value =
                                                !controller.showPassword.value,
                                            icon: Icon(
                                              controller.showPassword.value
                                                  ? CupertinoIcons.eye_slash
                                                  : CupertinoIcons.eye,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          validator: (val) =>
                                              AppValidator.validatePassword(
                                                  value: val),
                                        ),
                                      ),
                                      Obx(
                                        () => ReUsableTextField(
                                          controller: controller
                                              .confirmPasswordController,
                                          hintText: 'Confirm Password',
                                          prefixIcon: Icon(
                                            Icons.lock_open_rounded,
                                            color: AppColors.primaryColor,
                                          ),
                                          obscureText: controller
                                              .showConfirmPassword.value,
                                          suffixIcon: IconButton(
                                            onPressed: () => controller
                                                    .showConfirmPassword.value =
                                                !controller
                                                    .showConfirmPassword.value,
                                            icon: Icon(
                                              controller
                                                      .showConfirmPassword.value
                                                  ? CupertinoIcons.eye_slash
                                                  : CupertinoIcons.eye,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          validator: (val) =>
                                              AppValidator.validatePassword(
                                                  value: val),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: context.height * 0.01),
                                Obx(
                                  () => CustomButton(
                                    isLoading: controller.isLoading.value,
                                    buttonText: 'Register',
                                    onTap: () {
                                      if (_signupFormKey.currentState!
                                          .validate()) {
                                        controller.registerUser();
                                        if (controller
                                                .passwordController.text ==
                                            controller.confirmPasswordController
                                                .text) {
                                        } else {
                                          ToastMessage.showToastMessage(
                                              message: 'Passwords do not match',
                                              backgroundColor: Colors.red);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: context.height * 0.02),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.isLoading.value = false;
                                      controller.fNameController.clear();
                                      controller.lNameController.clear();
                                      controller.emailController.clear();
                                      controller.passwordController.clear();
                                      controller.confirmPasswordController
                                          .clear();
                                      Get.to(
                                        () => const LoginScreen(),
                                        transition: Transition.size,
                                        duration: const Duration(seconds: 1),
                                      );
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Already have a account? ',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0),
                                        children: [
                                          TextSpan(
                                            text: 'Login',
                                            style: TextStyle(
                                                color: AppColors.blueTextColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
