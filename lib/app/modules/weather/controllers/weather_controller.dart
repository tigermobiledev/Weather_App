import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import '../../../../utils/extensions.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../data/models/forecast_model.dart';
import '../../../services/api_call_status.dart';

class WeatherController extends GetxController {
  static WeatherController get instance => Get.find();

  // hold current weather data
  late WeatherModel weatherModel;
  late ForecastDay forecastDay;

  // for update
  final dotIndicatorsId = 'DotIndicators';

  // for weather forecast
  final days = 7;
  //var selectedDay = 'Today';
  var selectedDay = Strings.today.tr;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // for weather card slider
  late PageController pageController;

  // for weather slider and dot indicator
  var currentPage = 0;

  @override
  void onInit() async {
    pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.8,
    );
    super.onInit();
  }

  @override
  void onReady() {
    weatherModel = Get.arguments;
    _initWeatherDetailModel();
    super.onReady();
  }

  void _initWeatherDetailModel() {
    forecastDay = weatherModel.forecast.forecastDays[0];
    apiCallStatus = ApiCallStatus.success;
    update();
  }

  /// when the user change the selected day
  onDaySelected(String day) {
    selectedDay = day;
    var index = weatherModel.forecast.forecastDays.indexWhere((fd) {
      return fd.date.convertToDay() == day;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    onCardSlided(index);
  }

  /// when the user slide the weather card
  onCardSlided(int index) {
    forecastDay = weatherModel.forecast.forecastDays[index];
    selectedDay = forecastDay.date.convertToDay();
    currentPage = index;
    update();
  }
}
