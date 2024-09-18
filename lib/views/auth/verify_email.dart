import 'package:app/controllers/auth_controllers.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_textfield.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        horizontal: context.width * 0.04),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomTextWidget(
                                text: 'Verify Your Email',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              const CustomTextWidget(
                                text:
                                    'Enter email address to verify your Account',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                fontStyle: FontStyle.italic,
                                maxLines: 4,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height: context.height * 0.03),
                                    ReUsableTextField(
                                      controller: controller.emailController,
                                      hintText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validateEmail(
                                              value: val),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: context.height * 0.03),
                              Obx(
                                () => CustomButton(
                                  isLoading: controller.isLoading.value,
                                  buttonText: 'Verify Email',
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      ToastMessage.showToastMessage(
                                          message: 'Please Enter your Email',
                                          backgroundColor: Colors.red);
                                    } else {
                                      controller.sendOtp(
                                          verifyOtpForForgetPassword: false);
                                    }
                                  },
                                ),
                              ),
                            ],
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
