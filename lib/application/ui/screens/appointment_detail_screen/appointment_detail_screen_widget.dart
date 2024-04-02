import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medical_appointments/application/domain/entity/appointment_record.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/application/ui/widgets/service_item_widget.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class AppointmentDetailScreenWidget extends StatelessWidget {
  final AppointmentRecord appointmentRecord;
  const AppointmentDetailScreenWidget(
      {super.key, required this.appointmentRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.shadowColor,
        title: Text(
          DateFormat('dd MMMM yyyy HH:mm', 'ru_RU').format(
            appointmentRecord.selectedDate,
          ),
          style: AppTextStyle.titleTextStyle(context),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 22),
            child: SvgPicture.asset(
              AppSvg.arrowBack,
              color: AppColors.grayLite,
              width: 20,
              height: 20,
            ),
          ),
        ),
        leadingWidth: 20 + 22,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              _DetailItemWidget(
                title: 'Дата приема',
                information: DateFormat('dd MMMM yyyy', 'ru_RU').format(
                  appointmentRecord.selectedDate,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _DetailItemWidget(
                title: 'Время приема',
                information: DateFormat('HH:mm', 'ru_RU').format(
                  appointmentRecord.selectedDate,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _PriceItemWidget(appointmentRecord: appointmentRecord),
              const SizedBox(
                height: 16,
              ),
              _DetailItemWidget(
                title: 'Врач',
                information: appointmentRecord.selectedDoctor.name,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Список услуг',
                style: AppTextStyle.mainTextStyleBold(context),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(
                  appointmentRecord.selectedServices.length,
                  (index) => ServiceItemWidget(
                    service: appointmentRecord.selectedServices[index],
                    isInMainMenu: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceItemWidget extends StatelessWidget {
  const _PriceItemWidget({
    required this.appointmentRecord,
  });

  final AppointmentRecord appointmentRecord;

  @override
  Widget build(BuildContext context) {
    double fullPrice = 0.0;
    for (var element in appointmentRecord.selectedServices) {
      final price = double.tryParse(element.price);
      fullPrice += price ?? 0;
    }

    return _DetailItemWidget(
      title: 'Стоимость',
      information: '${fullPrice.toStringAsFixed(2)} BYN',
    );
  }
}

class _DetailItemWidget extends StatelessWidget {
  final String title;
  final String information;
  const _DetailItemWidget({
    required this.title,
    required this.information,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.backItemTextStyle(
                context,
                color: AppColors.gray,
              ),
            ),
            Text(
              information,
              style: AppTextStyle.titleTextStyle(context),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        const _LineWidget(),
      ],
    );
  }
}

class _LineWidget extends StatelessWidget {
  const _LineWidget();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFDEDFE2),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 1,
      ),
    );
  }
}
