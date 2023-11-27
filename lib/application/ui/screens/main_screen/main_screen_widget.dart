import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:medical_appointments/application/domain/blocs/appointment_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_time_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/doctor_bloc.dart';
import 'package:medical_appointments/application/domain/blocs/service_bloc.dart';
import 'package:medical_appointments/application/domain/entity/doctor.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/main_navigation/main_navigation.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';
import 'package:medical_appointments/application/ui/widgets/material_bottom_bar_widget.dart';
import 'package:medical_appointments/application/ui/widgets/service_item_widget.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int index = 0;

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.shadowColor,
        title: Text(
          'Запись на прием',
          style: AppTextStyle.titleTextStyle(context),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _FloatingActionButtonWidget(),
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
      ),
      body: AnimatedSwitcher(
        switchInCurve: Curves.decelerate,
        switchOutCurve: Curves.decelerate,
        duration: const Duration(milliseconds: 200),
        child: _buildScreen(index),
      ),
    );
  }

  Widget _buildScreen(int currentTabIndex) {
    switch (currentTabIndex) {
      case 0:
        return BlocProvider(
          create: (context) =>
              AppointmentBloc()..add(AppointmentLoadInitialData()),
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
      default:
        return Text(currentTabIndex.toString());
    }
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
              BlocBuilder<DoctorBloc, DoctorState>(
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
                    final appointmentBloc = context.read<AppointmentBloc>();
                    final doctor =
                        appointmentBloc.state is AppointmentStepChanged
                            ? (appointmentBloc.state as AppointmentStepChanged)
                                .selectedDoctor
                            : null;
                    final kod = doctor?.kod;

                    return Column(
                      children: List.generate(
                        state.doctors.length,
                        (index) => _DoctorsListItemWidget(
                          configuration: state.doctors[index],
                          isSelected:
                              kod != null && kod == state.doctors[index].kod,
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
              ),
            ],
          ),
        );

      case 1:
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
              BlocBuilder<ServiceBloc, ServiceState>(
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
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Выберите дату приема',
                style: AppTextStyle.backItemTextStyle(
                  context,
                  color: AppColors.gray,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.whiteLite,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppTheme.mainBoxShadows(context),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 26,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.gray,
                            ),
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            context
                                .read<AppointmentTimeBloc>()
                                .add(ChangeMonth(false));
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 14,
                          ),
                        ),
                      ),
                      BlocBuilder<AppointmentTimeBloc, AppointmentTimeState>(
                        builder: (context, state) {
                          String monthName = DateFormat('LLLL yyyy', 'ru_RU')
                              .format(state.selectedMonth);
                          String capitalizedMonthName =
                              monthName[0].toUpperCase() +
                                  monthName.substring(1);

                          return AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 150,
                            ),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              capitalizedMonthName,
                              key: ValueKey<String>(capitalizedMonthName),
                              style: AppTextStyle.buttonTextStyle(context),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 26,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.gray,
                            ),
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            context
                                .read<AppointmentTimeBloc>()
                                .add(ChangeMonth(true));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            const _DaySelectionWidget(),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Выберите время приема',
                style: AppTextStyle.backItemTextStyle(
                  context,
                  color: AppColors.gray,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const _TimeSelectionWidget(),
            const SizedBox(
              height: 120,
            ),
          ],
        );
      default:
        return const Text("Неизвестный шаг");
    }
  }
}

class _TimeSelectionWidget extends StatelessWidget {
  const _TimeSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeIntervals = List<TimeOfDay>.generate(
      15,
      (index) => TimeOfDay(hour: 10 + index ~/ 2, minute: 30 * (index % 2)),
    )
        .where(
          (time) => time.hour < 17 || (time.hour == 17 && time.minute <= 30),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: BlocBuilder<AppointmentTimeBloc, AppointmentTimeState>(
        builder: (context, state) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            children: _createTableRows(
              timeIntervals,
              context,
              state.selectedTime?.format(context) ?? "",
            ),
          );
        },
      ),
    );
  }

  List<TableRow> _createTableRows(
    List<TimeOfDay> timeIntervals,
    BuildContext context,
    String selectedTime,
  ) {
    List<TableRow> rows = [];
    for (int i = 0; i < timeIntervals.length; i += 4) {
      rows.add(
        TableRow(
          children: List.generate(
            4,
            (index) {
              if (i + index < timeIntervals.length) {
                final time = timeIntervals[i + index];
                final isSelected = time.format(context) == selectedTime;
                return GestureDetector(
                  onTap: () {
                    context.read<AppointmentTimeBloc>().add(SelectTime(time));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.pink : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppTheme.mainBoxShadows(context),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Center(
                        child: Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyle.secondNameTextStyle(
                            context,
                            color: isSelected ? AppColors.white : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      );
    }
    return rows;
  }
}

class _DaySelectionWidget extends StatelessWidget {
  const _DaySelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentTimeBloc, AppointmentTimeState>(
      builder: (context, state) {
        final now = DateTime.now();
        final firstDayOfMonth =
            DateTime(state.selectedMonth.year, state.selectedMonth.month, 1);
        final lastDayOfMonth = DateTime(
            state.selectedMonth.year, state.selectedMonth.month + 1, 0);

        final days = List.generate(
                lastDayOfMonth.day - firstDayOfMonth.day + 1,
                (index) => DateTime(firstDayOfMonth.year, firstDayOfMonth.month,
                    firstDayOfMonth.day + index))
            .where((day) => day.isAfter(now.subtract(const Duration(days: 1))))
            .toList();

        return SizedBox(
          height: 80,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = state.selectedDate?.day == day.day &&
                  state.selectedDate?.month == day.month;
              return GestureDetector(
                onTap: () {
                  context.read<AppointmentTimeBloc>().add(SelectDate(day));
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 22 : 0,
                    right: index == days.length - 1 ? 22 : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.pink : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppTheme.mainBoxShadows(context),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E', 'ru_RU').format(day).toUpperCase(),
                            style: AppTextStyle.topMenuTextStyle(
                              context,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.grayLite,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat('dd.MM', 'ru_RU').format(day),
                            style: AppTextStyle.secondNameTextStyle(
                              context,
                              color: isSelected ? AppColors.white : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 10,
              );
            },
          ),
        );
      },
    );
  }
}

class _AddNewServiceMessageWidget extends StatelessWidget {
  const _AddNewServiceMessageWidget({
    super.key,
  });

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
  const _AddNewServiceButtonWidget({
    super.key,
  });

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
        onPressed: () {
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
                final newState =
                    appointmentBloc.state as AppointmentStepChanged;
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
        },
        child: Text(
          'Добавить услугу',
          style: AppTextStyle.buttonTextStyleSemiBold(context),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();

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
            onPressed: () {
              final nextStep = appointmentBloc.currentStep + 1;

              if (nextStep > 3) return;
              final isStepChangedState =
                  appointmentBloc.state is AppointmentStepChanged;
              if (!isStepChangedState) return;

              final state = appointmentBloc.state as AppointmentStepChanged;

              if (nextStep == 1 && state.selectedDoctor == null ||
                  nextStep == 2 && state.selectedService == null) {
                return;
              } else if (nextStep == 3) {
                final appointmentTimeBloc = context.read<AppointmentTimeBloc>();
                final dayDate = appointmentTimeBloc.state.selectedDate;
                if (dayDate == null ||
                    dayDate.isAtSameMomentAs(DateTime(2023))) {
                  return;
                }

                final selectedTime = appointmentTimeBloc.state.selectedTime;
                if (selectedTime == null || selectedTime.hour == 0) return;

                final monthDate = appointmentTimeBloc.state.selectedMonth;

                final datetime = DateTime(
                  monthDate.year,
                  monthDate.month,
                  dayDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                appointmentBloc.add(
                  AppointmentUpdateStateEvent(
                    selectedDoctor: state.selectedDoctor,
                    selectedService: state.selectedService,
                    selectedTime: datetime,
                  ),
                );
              }

              if (nextStep == 1) {
                if (state.selectedDoctor == null) return;

                final serviceBloc = context.read<ServiceBloc>();
                serviceBloc.add(LoadServices(state.selectedDoctor!.kod));
                appointmentBloc
                    .add(AppointmentUpdateStateEvent(step: nextStep));
              } else if (nextStep == 2) {
                if (state.selectedService == null ||
                    state.selectedService!.isEmpty) {
                  return;
                }
                appointmentBloc
                    .add(AppointmentUpdateStateEvent(step: nextStep));
              } else if (nextStep == 3) {
                final state = appointmentBloc.state as AppointmentStepChanged;
                //
              }
            },
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

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();

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
      onPressed: () {
        final nextStep = appointmentBloc.currentStep - 1;
        if (nextStep < 0) return;

        appointmentBloc.add(AppointmentUpdateStateEvent(step: nextStep));
      },
      child: SvgPicture.asset(AppSvg.arrowLeft),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
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
        },
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
  const _LineWidget({
    super.key,
  });

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

class _FloatingActionButtonWidget extends StatelessWidget {
  const _FloatingActionButtonWidget();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.pink,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: const CircleBorder(),
      child: SvgPicture.asset(AppSvg.liPlus),
    );
  }
}
