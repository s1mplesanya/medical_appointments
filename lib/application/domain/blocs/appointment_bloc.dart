import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';

abstract class AppointmentEvent {}

class AppointmentLoadInitialData extends AppointmentEvent {}

// class AppointmentGoToStep extends AppointmentEvent {
//   final int step;
//   AppointmentGoToStep(this.step);
// }

class AppointmentUpdateStateEvent extends AppointmentEvent {
  final Doctor? selectedDoctor;
  final Service? selectedService;
  final DateTime? selectedTime;
  final int? step;

  AppointmentUpdateStateEvent({
    this.selectedDoctor,
    this.selectedService,
    this.selectedTime,
    this.step,
  });
}

// Состояния
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentStepChanged extends AppointmentState {
  final Doctor? selectedDoctor;
  final Service? selectedService;
  final DateTime? selectedTime;
  final int currentStep;

  AppointmentStepChanged({
    this.selectedDoctor,
    this.selectedService,
    this.selectedTime,
    this.currentStep = 0,
  });

  // Метод для обновления состояния
  AppointmentStepChanged copyWith({
    Doctor? selectedDoctor,
    Service? selectedService,
    DateTime? selectedTime,
    int? currentStep,
  }) {
    return AppointmentStepChanged(
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedService: selectedService ?? this.selectedService,
      selectedTime: selectedTime ?? this.selectedTime,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<AppointmentLoadInitialData>(_onLoadInitialData);
    // on<AppointmentGoToStep>(_onGoToStep);
    on<AppointmentUpdateStateEvent>(_updateCurrentState);
  }

  int _currentStep = 0;
  int get currentStep => _currentStep;

  void _onLoadInitialData(
      AppointmentLoadInitialData event, Emitter<AppointmentState> emit) {
    // Здесь может быть ваша логика загрузки начальных данных
    emit(AppointmentInitial());
  }

  // void _onGoToStep(AppointmentGoToStep event, Emitter<AppointmentState> emit) {
  //   _currentStep = event.step;
  //   emit(AppointmentStepChanged(
  //     currentStep: event.step,
  //   ));
  // }

  void _updateCurrentState(
      AppointmentUpdateStateEvent event, Emitter<AppointmentState> emit) {
    if (event.step != null) _currentStep = event.step!;
    final currentState = state;
    if (currentState is AppointmentStepChanged) {
      emit(currentState.copyWith(
        currentStep: event.step ?? currentState.currentStep,
        selectedDoctor: event.selectedDoctor ?? currentState.selectedDoctor,
        selectedService: event.selectedService ?? currentState.selectedService,
        selectedTime: event.selectedTime ?? currentState.selectedTime,
      ));
    } else {
      emit(AppointmentStepChanged(
        currentStep: event.step ?? 0,
        selectedDoctor: event.selectedDoctor,
        selectedService: event.selectedService,
        selectedTime: event.selectedTime,
      ));
    }
  }
}
