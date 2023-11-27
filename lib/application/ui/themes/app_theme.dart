import 'package:flutter/material.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';

abstract class AppTheme {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      fontFamily: 'Inter',
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: AppColors.gray,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyle.bottomNavBarTextStyle(context),
        unselectedLabelStyle: AppTextStyle.bottomNavBarTextStyle(context),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
        bodySmall: TextStyle(color: AppColors.black),
      ),
      primaryTextTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.black),
      ),
      // textSelectionTheme: const TextSelectionThemeData(
      //   cursorColor: AppColors.gray2, // Замените цвет курсора на белый
      //   selectionColor: AppColors.gray0,
      //   selectionHandleColor:
      //       AppColors.gray2, // Замените цвет ручки выделения на белый
      // ),
      // cupertinoOverrideTheme: const CupertinoThemeData(
      //   primaryColor: AppColors.gray0, // Замените основной цвет на белый
      // ),
      useMaterial3: true,
      // colorSchemeSeed: AppColors.blue,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          // borderSide: const BorderSide(
          //   color: AppColors.gray0,
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          // borderSide: const BorderSide(
          //   color: AppColors.gray0,
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          // borderSide: const BorderSide(color: AppColors.gray0),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static List<BoxShadow> mainBoxShadows(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.shadowColor1,
        blurRadius: 40,
      ),
    ];
  }
  // static ButtonStyle mainButtonStyle(BuildContext context) {
  //   return const ButtonStyle(
  //     backgroundColor: MaterialStatePropertyAll(AppColors.blue),
  //     padding: MaterialStatePropertyAll(
  //       EdgeInsets.symmetric(vertical: 24),
  //     ),
  //     shape: MaterialStatePropertyAll(
  //       RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(20)),
  //       ),
  //     ),
  //   );
  // }
}
