import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/storage_helper.dart';
import 'package:app/views/auth/login.dart';
import 'package:app/views/auth/onboarding/reusable_on_boarding_screen.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _DoctorBoardingScreenState();
}

class _DoctorBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: context.height * 0.25),
                  child: Image.asset(
                    'assets/images/app-logo-white.png',
                    height: context.height * 0.1,
                  ),
                )),
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              children: const [
                ReUsableBoardingScreen(
                  text: 'Welcome to Mechanix',
                  subText: 'Trusted Companion for Maintenance and Repair.',
                ),
                ReUsableBoardingScreen(
                  text: 'Effortless Task Management',
                  subText:
                      'Streamline Your Workflow with Intuitive Task Creation and Reporting.',
                ),
                ReUsableBoardingScreen(
                  text: 'Seamless Communication with Clients',
                  subText:
                      'Keep Your Clients Informed with Detailed Reports Sent Directly to Their Inbox.',
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: const Alignment(0, 0.2),
                    child: SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.blueTextColor,
                            strokeWidth: 1,
                            dotHeight: 5)),
                  ),
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: context.width * 0.2),
                    child: CustomButton(
                      isLoading: false,
                      buttonText: currentPageIndex < 2 ? 'Next' : 'Get Started',
                      onTap: () {
                        if (currentPageIndex < 2) {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        } else {
                          storage.write('isFirstTime', false);
                          Get.offAll(() => const LoginScreen(),
                              transition: Transition.size);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
