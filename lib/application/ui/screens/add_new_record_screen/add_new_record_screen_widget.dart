import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class AddNewRecordScreenWidget extends StatelessWidget {
  final List<Service> services;
  const AddNewRecordScreenWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    // final serviceBloc = context.read<ServiceBloc>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        shadowColor: AppColors.shadowColor,
        title: Text(
          'Выбор услуги',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            ...List.generate(
              services.length,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 22, right: 22, bottom: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.whiteLite.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(services[index].name),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SvgPicture.asset(
                            AppSvg.lineDash,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Стоимость процедуры: ',
                                style: AppTextStyle.topMenuTextStyleLight(
                                  context,
                                  color: AppColors.gray,
                                ),
                              ),
                              TextSpan(
                                text: '${services[index].price} BYN',
                                style: AppTextStyle.topMenuTextStyleSemiBold(
                                  context,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
