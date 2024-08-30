import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:get/get.dart';

class CustomRadioButton extends StatelessWidget {
  final String heading;
  final List<String> options;
  final String? selected;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;
  final Function(String) onChange;

  const CustomRadioButton({
    super.key,
    required this.heading,
    required this.options,
    required this.selected,
    this.showDeleteIcon = false,
    this.onDelete,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOption = Rx<String?>(selected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 6.0),
        CustomTextWidget(
          text: heading,
          fontWeight: FontWeight.w500,
          maxLines: 2,
          fontSize: 12,
        ),
        Obx(
          () => ReUsableContainer(
            showDeleteIcon: showDeleteIcon,
            onDelete: onDelete,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        activeColor: AppColors.blueTextColor,
                        value: option,
                        groupValue: selectedOption.value,
                        onChanged: (value) {
                          selectedOption.value = value;
                          if (value is String) onChange(value);
                        },
                      ),
                      CustomTextWidget(
                        text: option,
                        fontSize: 11.0,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
