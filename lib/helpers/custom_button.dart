import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? borderColor;
  final double width;
  final double? height;
  final double? fontSize;
  final bool usePrimaryColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.width = double.infinity,
    this.textColor,
    this.borderColor,
    this.height,
    this.usePrimaryColor = false,
    this.fontSize,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          isLoading ? null : onTap();
        },
        child: ReUsableContainer(
          width: width,
          verticalPadding: context.height * 0.01,
          height: height ?? 50,
          color: usePrimaryColor
              ? AppColors.primaryColor
              : AppColors.secondaryColor,
          child: Center(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitRing(
                        lineWidth: 2.0,
                        color: usePrimaryColor ? Colors.black87 : Colors.white,
                      ),
                    )
                  : CustomTextWidget(
                      text: buttonText,
                      fontSize: fontSize ?? 14,
                      textColor:
                          usePrimaryColor ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    )),
        ));
  }
}
