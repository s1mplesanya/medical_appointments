import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/screens/add_new_record_screen/add_new_record_screen_widget.dart';
import 'package:medical_appointments/application/ui/screens/main_screen/main_screen_widget.dart';
import 'package:flutter/material.dart';

class ScreenFactory {
  Widget makeMainTabsScreen() {
    return const MainScreenWidget();
  }

  Widget makeAddNewRecordScreen(List<Service> services) {
    return AddNewRecordScreenWidget(
      services: services,
    );
  }
}
