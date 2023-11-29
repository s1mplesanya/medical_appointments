import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_time_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/doctor_bloc.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';

class FirstStepWidget extends StatelessWidget {
  const FirstStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите лечащего врача',
            style: AppTextStyle.backItemTextStyle(
              context,
              color: AppColors.gray,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const _SelectDoctorListWidget(),
        ],
      ),
    );
  }
}

class _SelectDoctorListWidget extends StatelessWidget {
  const _SelectDoctorListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorsLoading) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.pink,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Загрузка...',
                  style: AppTextStyle.backItemTextStyle(context),
                ),
              ],
            ),
          );
        } else if (state is DoctorsLoaded) {
          final appointmentBloc = context.watch<AppointmentBloc>();
          final doctor = appointmentBloc.state is AppointmentStepChanged
              ? (appointmentBloc.state as AppointmentStepChanged).selectedDoctor
              : null;
          final kod = doctor?.kod;

          return Column(
            children: List.generate(
              state.doctors.length,
              (index) => _DoctorsListItemWidget(
                configuration: state.doctors[index],
                isSelected: kod != null && kod == state.doctors[index].kod,
              ),
            ),
          );
        } else if (state is DoctorError) {
          return const Center(
            child: Text("Ошибка загрузки докторов"),
          );
        }
        return Container();
      },
    );
  }
}

class _DoctorsListItemWidget extends StatelessWidget {
  final Doctor configuration;
  final bool isSelected;
  const _DoctorsListItemWidget({
    required this.configuration,
    required this.isSelected,
  });

  void onTap(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    if (appointmentBloc.state is AppointmentStepChanged) {
      final state = appointmentBloc.state as AppointmentStepChanged;
      appointmentBloc.add(
        AppointmentUpdateStateEvent(
          selectedDoctor: configuration,
          selectedService: state.selectedService,
          selectedTime: state.selectedTime,
        ),
      );
    } else {
      appointmentBloc.add(
        AppointmentUpdateStateEvent(
          selectedDoctor: configuration,
        ),
      );
    }
    context.read<AppointmentTimeBloc>().add(SelectDate(DateTime(2023)));
    context.read<AppointmentTimeBloc>().add(
          SelectTime(
            const TimeOfDay(hour: 0, minute: 0),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => onTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppTheme.mainBoxShadows(context),
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: AppColors.pink,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    configuration.img,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      configuration.name,
                      style: AppTextStyle.secondNameTextStyle(context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      configuration.dolzhnost,
                      style: AppTextStyle.doctorTitleTextStyle(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
