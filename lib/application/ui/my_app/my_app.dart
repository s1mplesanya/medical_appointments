import 'package:medical_appointments/application/ui/main_navigation/main_navigation.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(context),
      routes: mainNavigation.routes,
      initialRoute: MainNavigationScreens.mainScreen,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
