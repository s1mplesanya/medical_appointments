import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget({
    super.key,
    required this.index,
    required this.onChangedTab,
  });

  @override
  State<TabBarMaterialWidget> createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        icon: SvgPicture.asset(AppSvg.hospital),
        onPressed: null,
      ),
    );

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            svgIcon: AppSvg.hospital,
            title: 'Главная',
          ),
          buildTabItem(
            index: 1,
            svgIcon: AppSvg.calendar,
            title: 'Календарь',
          ),
          placeholder,
          buildTabItem(
            index: 2,
            svgIcon: AppSvg.layers,
            title: 'Записи',
          ),
          buildTabItem(
            index: 3,
            svgIcon: AppSvg.profile,
            title: 'Аккаунт',
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required String svgIcon,
    required String title,
  }) {
    final isSelected = index == widget.index;
    final color = isSelected ? AppColors.pink : AppColors.gray;
    return IconButton(
      icon: Column(
        children: [
          SvgPicture.asset(
            svgIcon,
            color: color,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            title,
            style: AppTextStyle.bottomNavBarTextStyle(
              context,
              color: color,
            ),
          ),
        ],
      ),
      onPressed: () => widget.onChangedTab(index),
    );
  }
}
