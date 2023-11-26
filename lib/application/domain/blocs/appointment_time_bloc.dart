import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppointmentTimeEvent {}

class SelectTime extends AppointmentTimeEvent {
  final DateTime time;
  SelectTime(this.time);
}

abstract class AppointmentTimeState {}

class AppointmentTimeInitial extends AppointmentTimeState {}

class TimeSelected extends AppointmentTimeState {
  final DateTime selectedTime;
  TimeSelected(this.selectedTime);
}

class AppointmentTimeBloc
    extends Bloc<AppointmentTimeEvent, AppointmentTimeState> {
  AppointmentTimeBloc() : super(AppointmentTimeInitial()) {
    on<SelectTime>(_onSelectTime);
  }

  void _onSelectTime(SelectTime event, Emitter<AppointmentTimeState> emit) {
    emit(TimeSelected(event.time));
  }
}
