import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SideMenuCard extends StatelessWidget {
  const SideMenuCard(
      {super.key,
      required this.sideMenu,
      required this.scaffoldKey,
      required this.controller});

  final UniversalController controller;
  final SideMenuController sideMenu;
  final GlobalKey<ScaffoldState> scaffoldKey;

  // final EnginesController _enginesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.isLandscape
          ? const EdgeInsets.all(16.0)
          : const EdgeInsets.all(0.0),
      child: ReUsableContainer(
        child: SideMenu(
          controller: sideMenu,
          style: _buildSideMenuStyle(context),
          title: _buildSideMenuTitle(),
          items: _buildSideMenuItems(),
        ),
      ),
    );
  }

  SideMenuStyle _buildSideMenuStyle(BuildContext context) {
    return SideMenuStyle(
      compactSideMenuWidth: 200,
      displayMode: SideMenuDisplayMode.open,
      showHamburger: context.isLandscape ? true : false,
      unselectedIconColor: AppColors.blueTextColor,
      itemInnerSpacing: 8.0,
      hoverColor: AppColors.primaryColor,
      selectedColor: AppColors.blueTextColor,
      selectedIconColor: Colors.white,
      selectedTitleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      unselectedTitleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildSideMenuTitle() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 120,
            maxWidth: 120,
          ),
          child: Image.asset('assets/images/app-logo.png'),
        ),
        const Divider(indent: 8.0, endIndent: 8.0),
      ],
    );
  }

  List<SideMenuItem> _buildSideMenuItems() {
    return [
      _buildSideMenuItem(
        title: 'Home',
        icon: CupertinoIcons.home,
        onTap: (index, _) {
          sideMenu.changePage(index);
          scaffoldKey.currentState?.closeDrawer();
          controller.fetchUserAnalyticsData();
        },
      ),
      _buildSideMenuItem(
        title: 'Tasks',
        icon: CupertinoIcons.create_solid,
        tooltipContent: 'Add Task',
        onTap: (index, _) {
          sideMenu.changePage(index);
          scaffoldKey.currentState?.closeDrawer();
        },
      ),
      _buildSideMenuItem(
        title: 'Engines',
        icon: FontAwesomeIcons.searchengin,
        onTap: (index, _) {
          sideMenu.changePage(index);
          scaffoldKey.currentState?.closeDrawer();
          // _enginesController.getAllEngines(page: 1);
        },
      ),
      SideMenuItem(
        builder: (context, displayMode) {
          return const Divider(endIndent: 8, indent: 8);
        },
      ),
      _buildSideMenuItem(
        title: 'Profile',
        icon: CupertinoIcons.person_fill,
        onTap: (index, _) {
          sideMenu.changePage(index);
          scaffoldKey.currentState?.closeDrawer();
        },
      ),
      _buildSideMenuItem(
        title: 'Terms & Conditions',
        icon: CupertinoIcons.doc_text_fill,
        onTap: (index, _) {
          sideMenu.changePage(index);
          scaffoldKey.currentState?.closeDrawer();
        },
      ),
    ];
  }

  SideMenuItem _buildSideMenuItem({
    required String title,
    IconData? icon,
    String? tooltipContent,
    void Function(int, SideMenuController)? onTap,
    Widget? trailing,
  }) {
    return SideMenuItem(
        title: title,
        trailing: trailing,
        icon: icon != null ? Icon(icon) : null,
        tooltipContent: tooltipContent,
        onTap: onTap);
  }
}
