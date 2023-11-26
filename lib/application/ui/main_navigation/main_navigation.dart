import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/domain/screen_factory/screen_factory.dart';
import 'package:flutter/material.dart';

abstract class MainNavigationScreens {
  static const mainScreen = '/';
  static const addNewRecord = '/addNewRecord';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationScreens.mainScreen: (_) =>
        _screenFactory.makeMainTabsScreen(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationScreens.addNewRecord:
        final recordsList = settings.arguments as List<Service>;
        return MaterialPageRoute(
            builder: (_) => _screenFactory.makeAddNewRecordScreen(recordsList));

      default:
        const widget = Text('Nagivation error!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}
