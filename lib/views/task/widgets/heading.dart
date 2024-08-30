import 'package:flutter/material.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContainerHeading extends StatelessWidget {
  final String heading;
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;
  final bool showIcons;

  const ContainerHeading({
    super.key,
    required this.heading,
    required this.onAdd,
    this.onDelete,
    required this.showIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(FontAwesomeIcons.circlePlus, color: Colors.transparent),
          Flexible(
            child: CustomTextWidget(
              text: heading,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ),
          showIcons
              ? Row(
                  children: [
                    InkWell(
                        onTap: onAdd,
                        child: const Icon(FontAwesomeIcons.circlePlus,
                            color: Colors.black54)),
                    const SizedBox(width: 6.0),
                    InkWell(
                        onTap: onDelete,
                        child:
                            const Icon(Icons.remove_circle, color: Colors.red)),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
