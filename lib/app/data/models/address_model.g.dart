// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) =>
    SuggestionModel()
      ..placeId = json['place_id'] as String
      ..name = json['main_text'] as String
      ..description = json['secondary_text'] as String? ?? ''
      ..latitude = (json['latitude'] as num?)?.toDouble() ?? 0.0
      ..longitude = (json['longitude'] as num?)?.toDouble() ?? 0.0;

Map<String, dynamic> _$SuggestionModelToJson(SuggestionModel instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'main_text': instance.name,
      'secondary_text': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
