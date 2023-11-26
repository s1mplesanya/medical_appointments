import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointments/application/domain/api_client/api_client.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';

abstract class ServiceEvent {}

class LoadServices extends ServiceEvent {
  final String doctorKod;
  LoadServices(this.doctorKod);
}

class SelectService extends ServiceEvent {
  final Service service;
  SelectService(this.service);
}

abstract class ServiceState {}

class ServicesInitial extends ServiceState {}

class ServicesLoading extends ServiceState {}

class ServicesLoaded extends ServiceState {
  final List<Service> services;
  final Service? selectedService;

  ServicesLoaded({required this.services, this.selectedService});
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServicesInitial()) {
    on<LoadServices>(_onLoadServices);
    on<SelectService>(_onSelectService);
  }

  void _onLoadServices(LoadServices event, Emitter<ServiceState> emit) async {
    emit(ServicesLoading());
    try {
      final apiClient = ApiClient();
      final services = await apiClient.fetchServices(event.doctorKod);
      emit(ServicesLoaded(services: services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  void _onSelectService(SelectService event, Emitter<ServiceState> emit) {
    if (state is ServicesLoaded) {
      emit(ServicesLoaded(
        services: (state as ServicesLoaded).services,
        selectedService: event.service,
      ));
    }
  }
}
