import 'package:json_annotation/json_annotation.dart';
part 'address_model.g.dart';

@JsonSerializable()
class SuggestionModel {
  SuggestionModel();

  @JsonKey(name: 'place_id')
  String placeId = '';
  @JsonKey(name: 'main_text')
  String name = '';
  @JsonKey(name: 'secondary_text', defaultValue: '')
  String description = '';
  @JsonKey(defaultValue: 0.0)
  double latitude = 0.0;
  @JsonKey(defaultValue: 0.0)
  double longitude = 0.0;

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);
}
