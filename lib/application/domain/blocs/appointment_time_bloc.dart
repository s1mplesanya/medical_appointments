import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentTimeEvent {}

class ChangeMonth extends AppointmentTimeEvent {
  final bool isNextMonth;
  ChangeMonth(this.isNextMonth);
}

class SelectDate extends AppointmentTimeEvent {
  final DateTime date;
  SelectDate(this.date);
}

class SelectTime extends AppointmentTimeEvent {
  final TimeOfDay time;
  SelectTime(this.time);
}

class AppointmentTimeState {
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  AppointmentTimeState({
    required this.selectedMonth,
    this.selectedDate,
    this.selectedTime,
  });

  AppointmentTimeState copyWith({
    DateTime? selectedMonth,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  }) {
    return AppointmentTimeState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class AppointmentTimeBloc
    extends Bloc<AppointmentTimeEvent, AppointmentTimeState> {
  AppointmentTimeBloc()
      : super(AppointmentTimeState(selectedMonth: DateTime.now())) {
    on<ChangeMonth>(_onChangeMonth);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
  }

  void _onChangeMonth(ChangeMonth event, Emitter<AppointmentTimeState> emit) {
    DateTime newMonth = state.selectedMonth;
    if (event.isNextMonth) {
      newMonth = DateTime(newMonth.year, newMonth.month + 1, 1);
    } else {
      if (newMonth.month == DateTime.now().month &&
          newMonth.year == DateTime.now().year) {
        return;
      }
      newMonth = DateTime(newMonth.year, newMonth.month - 1, 1);
    }
    emit(state.copyWith(selectedMonth: newMonth));
  }

  void _onSelectDate(SelectDate event, Emitter<AppointmentTimeState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectTime(SelectTime event, Emitter<AppointmentTimeState> emit) {
    emit(state.copyWith(selectedTime: event.time));
  }
}
