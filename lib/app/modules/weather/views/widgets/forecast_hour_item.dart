import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/current_model.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/translations/strings_enum.dart';

class ForecastHourItem extends StatelessWidget {
  final Current hour;
  const ForecastHourItem({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      margin: EdgeInsetsDirectional.only(end: 10.w),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hour.time.convertToTime(),
            style: theme.textTheme.bodySmall,
          ),
          Image(
            image: AssetImage('assets/icons/${hour.weatherCondition.icon}.png'),
            height: 50.h,
            width: 50.w,
          ),
          Text(
            '${hour.tempC.toInt().toString()}${Strings.celsius.tr}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
