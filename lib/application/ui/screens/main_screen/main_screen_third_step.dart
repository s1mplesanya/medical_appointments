import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_appointments/application/domain/blocs/appointment_time_bloc.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/themes/app_theme.dart';

class ThirdStepWidget extends StatelessWidget {
  const ThirdStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
        const _SelectMonthWidget(),
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
  }
}

class _SelectMonthWidget extends StatelessWidget {
  const _SelectMonthWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              const _PreviousMonthButtonWidget(),
              BlocBuilder<AppointmentTimeBloc, AppointmentTimeState>(
                builder: (context, state) {
                  String monthName = DateFormat('LLLL yyyy', 'ru_RU')
                      .format(state.selectedMonth);
                  String capitalizedMonthName =
                      monthName[0].toUpperCase() + monthName.substring(1);

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
              const _NextMonthButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviousMonthButtonWidget extends StatelessWidget {
  const _PreviousMonthButtonWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.gray,
          ),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          context.read<AppointmentTimeBloc>().add(ChangeMonth(false));
        },
        child: const Icon(
          Icons.arrow_back_ios_outlined,
          size: 14,
        ),
      ),
    );
  }
}

class _NextMonthButtonWidget extends StatelessWidget {
  const _NextMonthButtonWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.gray,
          ),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          context.read<AppointmentTimeBloc>().add(ChangeMonth(true));
        },
        child: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 14,
        ),
      ),
    );
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
                return _AppointmentTimeSelectWidget(
                  time: time,
                  isSelected: isSelected,
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

class _AppointmentTimeSelectWidget extends StatelessWidget {
  const _AppointmentTimeSelectWidget({
    required this.time,
    required this.isSelected,
  });

  final TimeOfDay time;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
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
