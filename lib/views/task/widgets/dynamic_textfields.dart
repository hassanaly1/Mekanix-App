import 'package:flutter/material.dart';
import 'package:app/views/task/widgets/heading_and_textfield.dart';

class DynamicTextFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final int? numberOfControllers;
  final String? hintText;

  const DynamicTextFields(
      {super.key,
      this.hintText,
      this.numberOfControllers,
      required this.controllers});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int i = 0; i < controllers.length; i += 2) {
      rows.add(
        Row(
          children: [
            Flexible(
              child: NumberWithTextField(
                number: '${i + 1}',
                hintText: controllers[i].text.toString(),
                controller: controllers[i],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Flexible(
              child: NumberWithTextField(
                number: '${i + 2}',
                hintText: controllers[i + 1].text.toString(),
                controller: controllers[i + 1],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class NumberWithTextField extends StatelessWidget {
  final String number;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const NumberWithTextField(
      {super.key,
      required this.number,
      this.controller,
      this.hintText,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return HeadingAndTextfieldInRow(
      title: number,
      hintText: hintText ?? 'Temperature',
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
    );
  }
}
