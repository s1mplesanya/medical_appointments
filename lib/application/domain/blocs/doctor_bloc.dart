// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medical_appointments/application/domain/api_client/api_client.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';

abstract class DoctorEvent {}

class LoadDoctors extends DoctorEvent {}

abstract class DoctorState {}

class DoctorsInitial extends DoctorState {}

class DoctorsLoading extends DoctorState {}

class DoctorsLoaded extends DoctorState {
  final List<Doctor> doctors;
  DoctorsLoaded({
    required this.doctors,
  });
}

class DoctorError extends DoctorState {
  final String error;
  DoctorError(this.error);
}

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc() : super(DoctorsInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
  }

  void _onLoadDoctors(LoadDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorsLoading());
    try {
      final apiClient = ApiClient();
      final doctors = await apiClient.fetchDoctors();
      emit(DoctorsLoaded(doctors: doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
