// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medical_appointments/application/domain/api_client/api_client.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';

abstract class ServiceEvent {}

class LoadServices extends ServiceEvent {
  final String doctorKod;
  LoadServices(this.doctorKod);
}

abstract class ServiceState {}

class ServicesInitial extends ServiceState {}

class ServicesLoading extends ServiceState {}

class ServicesLoaded extends ServiceState {
  final List<Service> services;

  ServicesLoaded({
    required this.services,
  });

  ServicesLoaded copyWith({
    List<Service>? services,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
    );
  }
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServicesInitial()) {
    on<LoadServices>(_onLoadServices);
  }

  void _onLoadServices(LoadServices event, Emitter<ServiceState> emit) async {
    emit(ServicesLoading());
    try {
      final apiClient = ApiClient();
      final services = await apiClient.fetchServices(event.doctorKod);
      emit(ServicesLoaded(
        services: services,
      ));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }
}
