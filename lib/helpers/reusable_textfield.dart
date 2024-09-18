import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ReUsableTextField extends StatelessWidget {
  final String hintText;
  final bool? readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool showBackgroundShadow;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;

  const ReUsableTextField({
    super.key,
    required this.hintText,
    this.onTap,
    this.readOnly,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.showBackgroundShadow = true,
    this.showDeleteIcon = false,
    this.onDelete,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ReUsableContainer(
      showDeleteIcon: showDeleteIcon,
      onDelete: onDelete,
      showBackgroundShadow: showBackgroundShadow,
      verticalPadding: context.height * 0.012,
      child: TextFormField(
        readOnly: readOnly ?? false,
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
        obscureText: obscureText,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.textColor,
        ),
        keyboardType: keyboardType,
        inputFormatters: [
          if (keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: 4.0),
          // isCollapsed: true,
          isDense: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: AppColors.lightTextColor,
          ),
          errorStyle: const TextStyle(
            fontSize: 10.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
