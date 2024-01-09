import 'package:json_annotation/json_annotation.dart';

part 'current_model.g.dart';

@JsonSerializable()
class Current {
  Current();
  @JsonKey(defaultValue: '', name: 'time')
  String time = '';

  @JsonKey(defaultValue: 0.0, name: 'temperature_2m')
  double tempC = 0.0;

  @JsonKey(defaultValue: 0.0, includeFromJson: false)
  double tempMaxC = 0.0;

  @JsonKey(defaultValue: 0.0, includeFromJson: false)
  double tempMinC = 0.0;

  @JsonKey(defaultValue: 0, name: 'is_day')
  int isDay = 0;

  @JsonKey(defaultValue: 0.0, name: 'wind_speed_10m')
  double windSpeed = 0.0;

  @JsonKey(defaultValue: 0, name: 'relative_humidity_2m')
  int humidity = 0;

  @JsonKey(defaultValue: 0, name: 'weather_code')
  int weatherCode = 0;

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

/*
* WMO Weather interpretation codes (WW)
Code	Description
0	Clear sky
1, 2, 3	Mainly clear, partly cloudy, and overcast
45, 48	Fog and depositing rime fog
51, 53, 55	Drizzle: Light, moderate, and dense intensity
56, 57	Freezing Drizzle: Light and dense intensity
61, 63, 65	Rain: Slight, moderate and heavy intensity
66, 67	Freezing Rain: Light and heavy intensity
71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
77	Snow grains
80, 81, 82	Rain showers: Slight, moderate, and violent
85, 86	Snow showers slight and heavy
95 *	Thunderstorm: Slight or moderate
96, 99 *	Thunderstorm with slight and heavy hail
* */

enum WeatherCondition {
  clearSky(0, 'sunny', 'Sunny'),
  clearSkyNight(100, 'moon', 'Clear Sky'),
  partlyCloudy(1, 'cloudy', 'Partly Cloudy'),
  cloudy(2, 'cloudy', 'Cloudy'),
  overcast(3, 'overcast', 'Overcast'),
  fog(45, 'foggy', 'Fog'),
  depositingRimeFog(48, 'foggy', 'Freezing Fog'),
  drizzle(51, 'drizzle', 'Drizzle'),
  drizzleModerate(53, 'drizzle', 'Moderate Drizzle'),
  drizzleDense(55, 'drizzle', 'Dense Drizzle'),
  freezingDrizzle(56, 'drizzle', 'Freezing Drizzle'),
  rain(61, 'light_rain', 'Slight Rain'),
  rainModerate(63, 'light_rain_shower', 'Moderate Rain'),
  rainHeavy(65, 'heavy_rain', 'Heavy Rain'),
  freezingLightRain(66, 'sleet', 'Freezing Light Rain'),
  freezingHeavyRain(67, 'sleet', 'Freezing Heavy Rain'),
  snowFallLight(71, 'snow', 'Light Snow Fall'),
  snowFallModerate(73, 'snow', 'Moderate Snow Fall'),
  snowFallHeavy(75, 'snow', 'Heavy Snow Fall'),
  snowGrains(77, 'snow', 'Snow Grains'),
  rainShowersSlight(80, 'light_rain_shower', 'Slight Rain Showers'),
  rainShowersModerate(81, 'showers', 'Moderate Rain Showers'),
  rainShowersViolent(82, 'heavy_showers', 'Violent Rain Showers'),
  snowShowersSlight(85, 'snow', 'Slight Snow Showers'),
  snowShowersHeavy(86, 'snow', 'Heavy Snow Showers'),
  thunderstorm(95, 'thunder', 'Thunderstorm'),
  thunderstormWithHail(96, 'thunder', 'Thunderstorm with Hail'),
  thunderstormWithHeavyHail(99, 'thunder', 'Thunderstorm with Heavy Hail');

  const WeatherCondition(this.code, this.icon, this.name);

  final int code;
  final String icon;
  final String name;
}

extension CurrentExtension on Current {
  DateTime get dateTime {
    return DateTime.parse(time);
  }

  int get hour {
    return dateTime.hour;
  }

  String get maxMinTemp {
    return '${tempMaxC.toInt()}°C / ${tempMinC.toInt()}°C';
  }

  WeatherCondition get weatherCondition {
    if (weatherCode == 0) {
      if (tempMaxC != 0.0 && tempMaxC > 0.0) return WeatherCondition.clearSky;

      return isDay == 1
          ? WeatherCondition.clearSky
          : WeatherCondition.clearSkyNight;
    }
    return WeatherCondition.values.firstWhere(
        (element) => element.code == weatherCode,
        orElse: () => WeatherCondition.clearSky);
  }
}
