import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/current_model.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/translations/strings_enum.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../routes/app_pages.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.weather, arguments: weather),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text(
                      weather.location.country.toRightCountry(),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    Text(
                      weather.location.name.toRightCity(),
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    20.verticalSpace,
                    Text(
                      weather.current.weatherCondition.name,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    10.verticalSpace,
                    Wrap(
                      children: [
                        Text(
                          '${Strings.humidity.tr}: ${weather.current.humidity}%',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          '${Strings.wind.tr}: ${weather.current.windSpeed} km/h',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().slideX(
                      duration: 200.ms,
                      begin: -1,
                      curve: Curves.easeInSine,
                    ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage(
                        'assets/icons/${weather.current.weatherCondition.icon}.png'),
                    height: 60.h,
                    width: 60.w,
                  ),
                  3.verticalSpace,
                  Text(
                    '${weather.current.tempC.round()}${Strings.celsius.tr}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ).animate().slideX(
                    duration: 200.ms,
                    begin: 1,
                    curve: Curves.easeInSine,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
