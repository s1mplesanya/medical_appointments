import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/appointments_screen_bloc.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/screens/add_new_record_screen/add_new_record_screen_widget.dart';
import 'package:medical_appointments/application/ui/screens/appointment_detail_screen/appointment_detail_screen_widget.dart';
import 'package:medical_appointments/application/ui/screens/appointments_screen/appointments_screen_widget.dart';
import 'package:medical_appointments/application/ui/screens/main_screen/main_screen_widget.dart';
import 'package:medical_appointments/application/ui/screens/main_tabs_screen/main_tabs_screen_widget.dart';
import 'package:flutter/material.dart';

class ScreenFactory {
  Widget makeMainTabsScreen() {
    return const MainTabsScreenWidget();
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeAddNewRecordScreen(List<Service> services) {
    return AddNewRecordScreenWidget(
      services: services,
    );
  }

  Widget makeAppointmentsScreen() {
    return BlocProvider(
      create: (context) => AppointmentsBloc()..add(LoadAppointments()),
      child: const AppointmentsScreenWidget(),
    );
  }

  Widget makeAppointmentsDetailScreen(AppointmentRecord appointmentRecord) {
    return AppointmentDetailScreenWidget(
      appointmentRecord: appointmentRecord,
    );
  }
}
