import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import '../../../../utils/extensions.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/weather_controller.dart';
import 'widgets/forecast_hour_item.dart';
import 'widgets/weather_details_card.dart';
import 'widgets/weather_details_item.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<WeatherController>(
          builder: (_) => MyWidgetsAnimator(
            apiCallStatus: controller.apiCallStatus,
            loadingWidget: () => const SizedBox.shrink(),
            errorWidget: () => ApiErrorWidget(
              retryAction: () => {},
            ),
            successWidget: () => SingleChildScrollView(
              child: Column(
                children: [
                  30.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                          backgroundColor: theme.primaryColor,
                        ),
                        PopupMenuButton<String>(
                          onSelected: controller.onDaySelected,
                          color: theme.cardColor,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context) => controller
                              .weatherModel.forecast.forecastDays
                              .map((fd) {
                            return PopupMenuItem<String>(
                              value: fd.date.convertToDay(),
                              child: Text(
                                fd.date.convertToDay(),
                                style: theme.textTheme.displaySmall,
                              ),
                            );
                          }).toList(),
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsetsDirectional.only(start: 8.w),
                            decoration: BoxDecoration(
                              color: theme.canvasColor,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(controller.selectedDay,
                                    style: theme.textTheme.bodyLarge),
                                8.horizontalSpace,
                                CustomIconButton(
                                  onPressed: null,
                                  icon: SvgPicture.asset(
                                    Constants.downArrow,
                                    fit: BoxFit.none,
                                  ),
                                  backgroundColor: theme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  AspectRatio(
                    aspectRatio: 1.1,
                    child: PageView.builder(
                      controller: controller.pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: controller.onCardSlided,
                      itemCount:
                          controller.weatherModel.forecast.forecastDays.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: controller.pageController,
                          builder: (context, child) {
                            double value = 0.0;
                            //print('abd: value=$value | index=$index');
                            if (controller
                                .pageController.position.haveDimensions) {
                              value = index.toDouble() -
                                  (controller.pageController.page ?? 0);
                              //value = (value * 0.038).clamp(-1, 1);
                              value = (value * 0.038).clamp(-1, 1);
                            } else {
                              // if(index == 0) value = controller.isEnLang ? -0.038 : 0.038;
                              // if(index == 1) value = 0.0;
                              // if(index == 2) value = controller.isEnLang ? 0.038 : -0.038;
                              if (index == 0) value = 0.0;
                              if (index == 1) {
                                value = 0.038;
                              }
                              if (index == 2) {
                                value = -0.038;
                              }
                            }
                            return Transform.rotate(
                              angle: pi * value,
                              child: WeatherDetailsCard(
                                address: controller.weatherModel.location.name,
                                forecastDay: controller
                                    .weatherModel.forecast.forecastDays[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  20.verticalSpace,
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: controller.currentPage,
                      count: 3,
                      effect: WormEffect(
                        activeDotColor: theme.primaryColor,
                        dotColor: theme.colorScheme.secondary,
                        dotWidth: 10.w,
                        dotHeight: 10.h,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Strings.weatherNow.tr,
                            style: theme.textTheme.displayMedium),
                        16.verticalSpace,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              WeatherDetailsItem(
                                title: Strings.wind.tr,
                                icon: Constants.wind,
                                value: controller.weatherModel.current.windSpeed
                                    .toInt()
                                    .toString(),
                                text: 'km/h',
                              ),
                              16.horizontalSpace,
                              WeatherDetailsItem(
                                title: Strings.humidity.tr,
                                icon: Constants.pressure,
                                value: controller.weatherModel.current.humidity
                                    .toInt()
                                    .toString(),
                                text: '%',
                                isHalfCircle: true,
                              ),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        Text(Strings.hoursForecast.tr,
                            style: theme.textTheme.displayMedium),
                        16.verticalSpace,
                        SizedBox(
                          height: 100.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.forecastDay.hour.length,
                            itemBuilder: (context, index) => ForecastHourItem(
                              hour: controller.forecastDay.hour[index],
                            ),
                          ),
                        ),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
