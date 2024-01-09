// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Current _$CurrentFromJson(Map<String, dynamic> json) => Current()
  ..time = json['time'] as String? ?? ''
  ..tempC = (json['temperature_2m'] as num?)?.toDouble() ?? 0.0
  ..isDay = json['is_day'] as int? ?? 0
  ..windSpeed = (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0
  ..humidity = json['relative_humidity_2m'] as int? ?? 0
  ..weatherCode = json['weather_code'] as int? ?? 0;

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.tempC,
      'is_day': instance.isDay,
      'wind_speed_10m': instance.windSpeed,
      'relative_humidity_2m': instance.humidity,
      'weather_code': instance.weatherCode,
    };
