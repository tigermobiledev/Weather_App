import 'current_model.dart';

class Forecast {
  List<ForecastDay> forecastDays;

  Forecast({required this.forecastDays});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List time = json['time'];
    List temperature_2m = json['temperature_2m'];
    List windSpeed10m = json['wind_speed_10m'];
    List relativeHumidity2m = json['relative_humidity_2m'];
    List weatherCode = json['weather_code'];
    List isDay = json['is_day'];
    List<ForecastDay> forecastDay = [];
    List<Current> hourItems = [];

    for (int i = 0; i < time.length; i++) {
      bool isNewDay = (i + 1) % 24 == 0;
      DateTime dateTime = DateTime.parse(time[i]);
      Current hourItem = Current();
      hourItem.tempC = temperature_2m[i];
      hourItem.windSpeed = windSpeed10m[i];
      hourItem.humidity = relativeHumidity2m[i];
      hourItem.weatherCode = weatherCode[i];
      hourItem.isDay = isDay[i];
      hourItem.time = time[i];
      hourItems.add(hourItem);
      if (isNewDay) {
        Current max = hourItems
            .reduce((curr, next) => curr.tempC > next.tempC ? curr : next);
        Current min = hourItems
            .reduce((curr, next) => curr.tempC < next.tempC ? curr : next);
        max.tempMaxC = max.tempC;
        max.tempMinC = min.tempC;
        forecastDay.add(ForecastDay(
          date: dateTime,
          day: max,
          hour: [...hourItems],
        ));
        hourItems.clear();
      }
    }
    return Forecast(forecastDays: forecastDay);
  }

  Map<String, dynamic> toJson() => {
        'forecastDays': List<dynamic>.from(forecastDays.map((x) => x.toJson())),
      };
}

class ForecastDay {
  DateTime date;
  Current day;
  List<Current> hour;

  ForecastDay({
    required this.date,
    required this.day,
    required this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
        date: DateTime.parse(json['date']),
        day: Current.fromJson(json['day']),
        hour: List<Current>.from(json['hour'].map((x) => Current.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'day': day.toJson(),
        'hour': List<dynamic>.from(hour.map((x) => x.toJson())),
      };
}
