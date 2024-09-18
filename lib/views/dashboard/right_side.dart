import 'package:app/views/dashboard/terms_and_conditions.dart';
import 'package:app/views/engines/engine.dart';
import 'package:app/views/home/home.dart';
import 'package:app/views/profile.dart';
import 'package:app/views/task/task.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

class RightSideWidget extends StatelessWidget {
  const RightSideWidget({
    super.key,
    required this.pageController,
    required this.sideMenu,
    required this.tabController,
  });

  final PageController pageController;
  final SideMenuController sideMenu;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const HomeScreen(),
          TaskScreen(sideMenu: sideMenu),
          EnginesScreen(sideMenu: sideMenu),
          Container(),
          ProfileSection(sideMenu: sideMenu),
          TermsAndConditionsScreen(sideMenu: sideMenu),
        ],
      ),
    );
  }
}
