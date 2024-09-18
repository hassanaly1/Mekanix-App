import 'package:app/helpers/custom_text.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final SideMenuController sideMenu;

  const TermsAndConditionsScreen({super.key, required this.sideMenu});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          sideMenu.changePage(0);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: CustomTextWidget(
                  text: 'Terms And Conditions',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * 0.02),
              const Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: '1. Acceptance of Terms',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'By using the Mekanix app, you agree to be bound by these terms and conditions, including any future amendments or updates. If you do not agree, please do not use the service.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '2. Eligibility',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'You must be at least 18 years old to use the Mekanix app.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '3. Service Description',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'Mekanix allows you to perform engine inspections, create engine reports, and send these reports to clients via email. You can also create templates of engines for future use.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '4. User Responsibilities',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text: 'You agree to:',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        CustomTextWidget(
                          text:
                              'a. Provide accurate information when creating engine reports.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        CustomTextWidget(
                          text:
                              'b. Use the app for lawful purposes and in accordance with these terms.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        CustomTextWidget(
                          text:
                              'c. Ensure the security of your account and not share your login credentials with others.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '5. Termination',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'We reserve the right to terminate or suspend your access to the Mekanix app at any time, without notice, for any reason, including violation of these terms.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '6. Liability',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'We are not liable for any damages or losses resulting from your use of the Mekanix app, including but not limited to errors in reports, data loss, or unauthorized access to your account.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '7. Privacy',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'Your personal information will be used in accordance with our Privacy Policy.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '8. Changes to Terms',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'We may update these terms and conditions from time to time. Continued use of the Mekanix app constitutes acceptance of the updated terms.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '9. Governing Law',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'These terms and conditions are governed by the laws of the jurisdiction in which you operate.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '10. Contact Information',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'For any questions or concerns, please contact our support team.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '11. User Data',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'You are responsible for maintaining the accuracy and confidentiality of your data within the Mekanix app.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '12. Feedback and Suggestions',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'We welcome your feedback and suggestions to improve Mekanix. Please share your thoughts through the designated feedback channels.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '13. Confidentiality',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'You agree to keep all client information and data generated within Mekanix confidential and not disclose it to any third party without authorization.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '14. Severability',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'If any provision of these terms is found to be invalid or unenforceable, the remaining provisions will remain in full force and effect.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '15. Entire Agreement',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'These terms and conditions constitute the entire agreement between you and the company regarding the use of the Mekanix app.',
                          fontSize: 14.0,
                          maxLines: 10,
                        ),
                        SizedBox(height: 10.0),
                        CustomTextWidget(
                          text: '16. Delete Account',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextWidget(
                          text:
                              'You have the right to delete your account at any time. To delete your account, navigate to the Profile tab within the app, located below the Logout button. Deleting your account will remove all your records from our database, and this action cannot be undone.',
                          fontSize: 14.0,
                          maxLines: 10,
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
    );
  }
}
