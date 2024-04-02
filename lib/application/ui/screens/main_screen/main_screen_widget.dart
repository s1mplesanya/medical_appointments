import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_appointments/application/domain/api_client/api_client.dart';

import 'package:medical_appointments/application/domain/blocs/appointment_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_time_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/doctor_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/service_bloc.dart';
import 'package:medical_appointments/application/domain/data_provider/box_manager.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';
import 'package:medical_appointments/application/ui/screens/main_screen/main_screen_first_step_widget.dart';
import 'package:medical_appointments/application/ui/screens/main_screen/main_screen_second_step_widget.dart';
import 'package:medical_appointments/application/ui/screens/main_screen/main_screen_third_step.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';
import 'package:medical_appointments/application/ui/widgets/custom_snack_bar_widget.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc()..add(AppointmentLoadInitialData()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DoctorBloc>(
            create: (_) => DoctorBloc()..add(LoadDoctors()),
          ),
          BlocProvider<ServiceBloc>(
            create: (_) => ServiceBloc(),
          ),
          BlocProvider<AppointmentTimeBloc>(
            create: (_) => AppointmentTimeBloc(),
          ),
        ],
        child: const _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: _StepsWidget(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  final currentStep =
                      context.read<AppointmentBloc>().currentStep;
                  return AnimatedSwitcher(
                    switchInCurve: Curves.decelerate,
                    switchOutCurve: Curves.decelerate,
                    duration: const Duration(milliseconds: 300),
                    child: _buildStepContent(context, currentStep),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
          ],
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 50,
              left: 22,
              right: 22,
            ),
            child: _MainButtonsWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context, int step) {
    switch (step) {
      case 0:
        return const FirstStepWidget();
      case 1:
        return const SecondStepWidget();
      case 2:
        return const ThirdStepWidget();
      default:
        return const Text("Неизвестный шаг");
    }
  }
}

class _MainButtonsWidget extends StatelessWidget {
  const _MainButtonsWidget();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        IntrinsicHeight(
          child: _BackButtonWidget(),
        ),
        SizedBox(
          width: 14,
        ),
        Expanded(
          child: _NextButtonWidget(),
        ),
      ],
    );
  }
}

class _NextButtonWidget extends StatelessWidget {
  const _NextButtonWidget();

  void onPressed(BuildContext context) async {
    final appointmentBloc = context.read<AppointmentBloc>();
    final nextStep = appointmentBloc.currentStep + 1;

    if (nextStep > 3) return;
    final isStepChangedState = appointmentBloc.state is AppointmentStepChanged;
    if (!isStepChangedState) {
      Future.microtask(
        () => CustomSnackbar.show(
            context: context, message: 'Вы не выбрали доктора!'),
      );
      return;
    }

    final state = appointmentBloc.state as AppointmentStepChanged;

    // Проверки для каждого шага
    if (nextStep == 1 && state.selectedDoctor == null) {
      Future.microtask(
        () => CustomSnackbar.show(
            context: context, message: 'Вы не выбрали доктора!'),
      );
      return;
    } else if (nextStep == 2 && state.selectedService == null) {
      Future.microtask(
        () => CustomSnackbar.show(
            context: context, message: 'Вы не выбрали услуги!'),
      );
      return;
    } else if (nextStep == 3) {
      final appointmentTimeBloc = context.read<AppointmentTimeBloc>();
      final dayDate = appointmentTimeBloc.state.selectedDate;
      if (dayDate == null || dayDate.isAtSameMomentAs(DateTime(2023))) {
        return;
      }

      final selectedTime = appointmentTimeBloc.state.selectedTime;
      if (selectedTime == null || selectedTime.hour == 0) return;
    }

    // Выполнение кнопки для каждого шага
    if (nextStep == 1) {
      if (state.selectedDoctor == null) return;

      final serviceBloc = context.read<ServiceBloc>();
      serviceBloc.add(LoadServices(state.selectedDoctor!.kod));
      appointmentBloc.add(AppointmentUpdateStateEvent(step: nextStep));
    } else if (nextStep == 2) {
      if (state.selectedService == null || state.selectedService!.isEmpty) {
        return;
      }
      appointmentBloc.add(AppointmentUpdateStateEvent(step: nextStep));
    } else if (nextStep == 3) {
      final appointmentTimeBloc = context.read<AppointmentTimeBloc>();
      final dayDate = appointmentTimeBloc.state.selectedDate;

      final selectedTime = appointmentTimeBloc.state.selectedTime;
      final monthDate = appointmentTimeBloc.state.selectedMonth;

      final datetime = DateTime(
        monthDate.year,
        monthDate.month,
        dayDate!.day,
        selectedTime!.hour,
        selectedTime.minute,
      );

      final appointmentBox = await BoxManager.instance.openAppointmentsBox();
      final newAppointment = AppointmentRecord(
        selectedDoctor: state.selectedDoctor!,
        selectedServices: state.selectedService!,
        selectedDate: datetime,
      );
      await appointmentBox.add(newAppointment);
      await BoxManager.instance.closeBox(appointmentBox);
      appointmentBloc.add(AppointmentGoToFirstStep());
      Future.microtask(
        () => CustomSnackbar.show(
            context: context, message: 'Запись успешно добавлена!'),
      );

      //
      final apiCLient = ApiClient();
      await apiCLient.addNewRecord(newAppointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        final currentStep = context.read<AppointmentBloc>().currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.pink,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 17,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              foregroundColor:
                  currentStep != 2 ? AppColors.pink : AppColors.white,
              backgroundColor: currentStep == 2 ? AppColors.pink : null,
            ),
            onPressed: () => onPressed(context),
            child: currentStep != 2
                ? Text(
                    'Продолжить',
                    style: AppTextStyle.buttonTextStyle(context),
                  )
                : Text(
                    'Забронировать',
                    style: AppTextStyle.mainTextStyleBold(context),
                  ),
          ),
        );
      },
    );
  }
}

class _BackButtonWidget extends StatelessWidget {
  const _BackButtonWidget();

  void onPressed(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();

    final nextStep = appointmentBloc.currentStep - 1;
    if (nextStep < 0) return;

    appointmentBloc.add(AppointmentUpdateStateEvent(step: nextStep));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppColors.gray,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 17,
        ),
        shape: const CircleBorder(),
      ),
      onPressed: () => onPressed(context),
      child: SvgPicture.asset(AppSvg.arrowLeft),
    );
  }
}

class _StepsWidget extends StatelessWidget {
  const _StepsWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppTheme.mainBoxShadows(context),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19),
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              final currentStep =
                  context.read<AppointmentBloc>().currentStep + 1;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepWidget(
                    step: 1,
                    stepTitle: 'Врач',
                    selectedStep: currentStep,
                  ),
                  const _LineWidget(),
                  _StepWidget(
                    step: 2,
                    stepTitle: 'Услуги',
                    selectedStep: currentStep,
                  ),
                  const _LineWidget(),
                  _StepWidget(
                    step: 3,
                    stepTitle: 'Дата',
                    selectedStep: currentStep,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StepWidget extends StatelessWidget {
  final String stepTitle;
  final int step;
  final int selectedStep;
  const _StepWidget({
    required this.stepTitle,
    required this.step,
    required this.selectedStep,
  });

  @override
  Widget build(BuildContext context) {
    late final Color color;
    if (selectedStep == step) {
      color = AppColors.pink;
    } else if (selectedStep < step) {
      color = AppColors.grayLite;
    } else {
      color = AppColors.black;
    }
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: AppTextStyle.topMenuTextStyle(
                  context,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        if (step == selectedStep)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              stepTitle,
              style: AppTextStyle.topMenuTextStyle(context),
            ),
          )
      ],
    );
  }
}

class _LineWidget extends StatelessWidget {
  const _LineWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFDEDFE2),
        ),
        child: SizedBox(
          width: 59,
          height: 1,
        ),
      ),
    );
  }
}
