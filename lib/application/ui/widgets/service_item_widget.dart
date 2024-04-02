import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical_appointments/application/domain/entity/service.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';
import 'package:medical_appointments/application/ui/themes/app_text_style.dart';
import 'package:medical_appointments/resourses/svgs.dart';

class ServiceItemWidget extends StatelessWidget {
  const ServiceItemWidget({
    super.key,
    required this.service,
    this.backgroundColor,
    this.isInMainMenu,
  });

  final Service service;
  final Color? backgroundColor;
  final bool? isInMainMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isInMainMenu == null
          ? const EdgeInsets.only(left: 22, right: 22, bottom: 12)
          : const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isInMainMenu == null
            ? () {
                Navigator.pop(context, service);
              }
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.whiteLite.withOpacity(0.7),
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
                Text(service.name),
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
                        text: '${service.price} BYN',
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
    );
  }
}
