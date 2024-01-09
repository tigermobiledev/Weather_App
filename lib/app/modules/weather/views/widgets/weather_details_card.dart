import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/current_model.dart';

import '../../../../data/models/forecast_model.dart';

class WeatherDetailsCard extends StatelessWidget {
  final String address;
  final ForecastDay forecastDay;
  const WeatherDetailsCard({
    super.key,
    required this.address,
    required this.forecastDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          20.verticalSpace,
          Image(
            image: AssetImage(
                'assets/icons/${forecastDay.day.weatherCondition.icon}.png'),
            height: 150.h,
            width: 150.w,
          ),
          15.verticalSpace,
          Text(
            address,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            forecastDay.day.maxMinTemp,
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 44.sp,
              color: Colors.white,
            ),
          ),
          16.verticalSpace,
          Text(
            forecastDay.day.weatherCondition.name,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
