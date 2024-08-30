import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/models/engine_model.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<EngineModel> items;
  final void Function(EngineModel?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return ReUsableContainer(
      padding: EdgeInsets.zero,
      child: DropdownButtonFormField(
        padding: EdgeInsets.zero,
        iconSize: 12.0,
        alignment: Alignment.centerLeft,
        isExpanded: false,
        hint: CustomTextWidget(
          text: hintText,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          textColor: AppColors.lightTextColor,
        ),
        isDense: true,
        dropdownColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: AppColors.lightTextColor,
        ),
        decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        items: items
            .map((options) => DropdownMenuItem(
                value: options,
                child: CustomTextWidget(
                  text: options.name ?? '',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  textColor: AppColors.textColor,
                )))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
