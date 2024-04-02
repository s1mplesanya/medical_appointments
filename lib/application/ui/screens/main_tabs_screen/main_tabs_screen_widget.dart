import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:medical_appointments/application/domain/screen_factory/screen_factory.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/widgets/material_bottom_bar_widget.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class MainTabsScreenWidget extends StatefulWidget {
  const MainTabsScreenWidget({super.key});

  @override
  State<MainTabsScreenWidget> createState() => _MainTabsScreenWidgetState();
}

class _MainTabsScreenWidgetState extends State<MainTabsScreenWidget> {
  int index = 0;

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.shadowColor,
        title: Text(
          'Запись на прием',
          style: AppTextStyle.titleTextStyle(context),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _FloatingActionButtonWidget(),
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
      ),
      body: AnimatedSwitcher(
        switchInCurve: Curves.decelerate,
        switchOutCurve: Curves.decelerate,
        duration: const Duration(milliseconds: 200),
        child: _buildScreen(index),
      ),
    );
  }

  Widget _buildScreen(int currentTabIndex) {
    final screenFactory = ScreenFactory();
    switch (currentTabIndex) {
      case 0:
        return screenFactory.makeMainScreen();
      case 2:
        return screenFactory.makeAppointmentsScreen();
      default:
        return Text(currentTabIndex.toString());
    }
  }
}

class _FloatingActionButtonWidget extends StatelessWidget {
  const _FloatingActionButtonWidget();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.pink,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: const CircleBorder(),
      child: SvgPicture.asset(AppSvg.liPlus),
    );
  }
}
