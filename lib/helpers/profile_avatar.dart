import 'package:flutter/material.dart';
import 'package:app/controllers/universal_controller.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final UniversalController controller = Get.find();
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: controller.userImageURL.value != ''
                ? NetworkImage(controller.userImageURL.value)
                : const AssetImage('assets/images/placeholder.png')
                    as ImageProvider),
      ),
    );
  }
}
