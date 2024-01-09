import 'package:weather_app/app/data/models/forecast_model.dart';

import 'current_model.dart';
import 'location_model.dart';

class WeatherModel {
  Location location;
  Current current;
  Forecast forecast;

  WeatherModel({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        location: Location.fromJson(json),
        current: Current.fromJson(json['current']),
        forecast: Forecast.fromJson(json['hourly']),
      );

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
        'current': current.toJson(),
      };
}
