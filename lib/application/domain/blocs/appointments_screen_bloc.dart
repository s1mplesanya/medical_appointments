import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:medical_appointments/application/domain/data_provider/box_manager.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';

abstract class AppointmentsEvent {}

class LoadAppointments extends AppointmentsEvent {}

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final Map<DateTime, List<AppointmentRecord>> groupedAppointments;
  AppointmentsLoaded(this.groupedAppointments);
}

class AppointmentsError extends AppointmentsState {
  final String error;
  AppointmentsError(this.error);
}

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  AppointmentsBloc() : super(AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
  }

  void _onLoadAppointments(
      LoadAppointments event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    try {
      final Map<DateTime, List<AppointmentRecord>> groupedAppointments =
          await _loadAppointmentsFromHive();
      emit(AppointmentsLoaded(groupedAppointments));
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<Map<DateTime, List<AppointmentRecord>>>
      _loadAppointmentsFromHive() async {
    final Box<AppointmentRecord> appointmentBox =
        await BoxManager.instance.openAppointmentsBox();

    final Map<DateTime, List<AppointmentRecord>> groupedAppointments = {};

    for (var i = 0; i < appointmentBox.length; i++) {
      final appointment = appointmentBox.getAt(i);
      if (appointment != null) {
        final date = appointment.selectedDate;
        final dayDateTime = DateTime(date.year, date.month, date.day);
        groupedAppointments[dayDateTime] =
            groupedAppointments[dayDateTime] ?? [];
        groupedAppointments[dayDateTime]!.add(appointment);
        groupedAppointments[dayDateTime]!
            .sort((a, b) => a.selectedDate.compareTo(b.selectedDate));
      }
    }

    await BoxManager.instance.closeBox(appointmentBox);

    return groupedAppointments;
  }
}
