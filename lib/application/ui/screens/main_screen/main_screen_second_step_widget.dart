import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/service_bloc.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/main_navigation/main_navigation.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';
import 'package:medical_appointments/application/ui/widgets/service_item_widget.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class SecondStepWidget extends StatelessWidget {
  const SecondStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Выбранные услуги',
                style: AppTextStyle.backItemTextStyle(
                  context,
                  color: AppColors.gray,
                ),
              ),
              SvgPicture.asset(AppSvg.info),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const _AddNewServiceMessageWidget(),
          const SizedBox(
            height: 16,
          ),
          const _AddNewServiceButtonWidget(),
          const SizedBox(
            height: 16,
          ),
          const _ServiceListWidget(),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}

class _ServiceListWidget extends StatelessWidget {
  const _ServiceListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
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
        } else if (state is ServicesLoaded) {
          final appointmentBloc = context.read<AppointmentBloc>();
          final appointmentState =
              appointmentBloc.state as AppointmentStepChanged;

          return Column(
            children: List.generate(
              appointmentState.selectedService?.length ?? 0,
              (index) => ServiceItemWidget(
                service: appointmentState.selectedService![index],
                backgroundColor: AppColors.white,
                isInMainMenu: true,
              ),
            ),
          );
        } else if (state is ServiceError) {
          return const Center(
            child: Text("Ошибка загрузки услуг"),
          );
        }
        return Container();
      },
    );
  }
}

class _AddNewServiceMessageWidget extends StatelessWidget {
  const _AddNewServiceMessageWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppTheme.mainBoxShadows(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 38,
          right: 38,
          top: 21,
          bottom: 26,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppSvg.exclamation),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  'Услуга не выбрана',
                  style: AppTextStyle.mainTextStyleBold(context),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Для добавления услуги нажмите кнопку «Добавить услугу»',
              style: AppTextStyle.exlTitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewServiceButtonWidget extends StatelessWidget {
  const _AddNewServiceButtonWidget();

  void onPressed(BuildContext context) {
    final serviceBloc = context.read<ServiceBloc>();
    if (serviceBloc.state is! ServicesLoaded) return;

    final state = serviceBloc.state as ServicesLoaded;
    Navigator.pushNamed(
      context,
      MainNavigationScreens.addNewRecord,
      arguments: state.services,
    ).then((value) {
      if (value != null) {
        final selectedService = value as Service;

        final appointmentBloc = context.read<AppointmentBloc>();
        if (appointmentBloc.state is AppointmentStepChanged) {
          final newState = appointmentBloc.state as AppointmentStepChanged;
          if (newState.selectedService != null &&
              newState.selectedService!.contains(selectedService)) {
            return;
          }

          final oldList = newState.selectedService ?? [];
          oldList.add(selectedService);
          appointmentBloc.add(
            AppointmentUpdateStateEvent(
              selectedDoctor: newState.selectedDoctor,
              selectedService: oldList,
              selectedTime: newState.selectedTime,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.pink,
          padding: const EdgeInsets.symmetric(
            vertical: 17,
          ),
        ),
        onPressed: () => onPressed(context),
        child: Text(
          'Добавить услугу',
          style: AppTextStyle.buttonTextStyleSemiBold(context),
        ),
      ),
    );
  }
}
