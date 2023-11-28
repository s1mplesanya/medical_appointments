import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:medical_appointments/application/domain/blocs/appointments_screen_bloc.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';
import 'package:medical_appointments/application/ui/main_navigation/main_navigation.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class AppointmentsScreenWidget extends StatelessWidget {
  const AppointmentsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsBloc, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AppointmentsLoaded) {
          final groupedAppointments = state.groupedAppointments;
          return _CustomAppointmentsWidget(groupedAppointments);
        } else if (state is AppointmentsError) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        } else {
          return const Center(
            child: Text('Unknown state'),
          );
        }
      },
    );
  }
}

class _CustomAppointmentsWidget extends StatelessWidget {
  final Map<DateTime, List<AppointmentRecord>> groupedAppointments;

  const _CustomAppointmentsWidget(this.groupedAppointments);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupedAppointments.length,
      itemBuilder: (context, index) {
        final date = groupedAppointments.keys.elementAt(index);
        final appointments = groupedAppointments[date] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                DateFormat('dd MMMM yyyy', 'ru_RU').format(date),
                style: AppTextStyle.backItemTextStyle(
                  context,
                  color: AppColors.gray,
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (var appointment in appointments)
              Padding(
                padding: const EdgeInsets.only(left: 22, right: 22, bottom: 11),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MainNavigationScreens.appointmentDetail,
                      arguments: appointment,
                    );
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 18,
                            ),
                            child: Text(
                              DateFormat('HH:mm', 'ru_RU')
                                  .format(appointment.selectedDate),
                              style: AppTextStyle.dateTextStyle(
                                context,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 11,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.selectedDoctor.name,
                                        style:
                                            AppTextStyle.topMenuTextStyleLight(
                                                context),
                                      ),
                                      Text(
                                        appointment.selectedDoctor.dolzhnost,
                                        style: AppTextStyle.dolznostTextStyle(
                                          context,
                                          color: AppColors.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SvgPicture.asset(AppSvg.dots),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
