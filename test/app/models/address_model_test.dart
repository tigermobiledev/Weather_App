import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/app/data/models/address_model.dart';

void main() {
  group('SuggestionModel', () {
    test('fromJson', () {
      final json = {
        'place_id': 'place_id',
        'main_text': 'main_text',
        'secondary_text': 'secondary_text',
        'latitude': 1.0,
        'longitude': 1.0,
      };
      final suggestionModel = SuggestionModel.fromJson(json);
      expect(suggestionModel.placeId, json["place_id"]);
      expect(suggestionModel.name, json["main_text"]);
      expect(suggestionModel.description, json["secondary_text"]);
      expect(suggestionModel.latitude, json["latitude"]);
      expect(suggestionModel.longitude, json["longitude"]);
    });

    test('toJson', () {
      final suggestionModel = SuggestionModel();
      suggestionModel.placeId = 'place_id';
      suggestionModel.name = 'main_text';
      suggestionModel.description = 'secondary_text';
      suggestionModel.latitude = 1.0;
      suggestionModel.longitude = 1.0;
      final json = suggestionModel.toJson();
      expect(json["place_id"], suggestionModel.placeId);
      expect(json["main_text"], suggestionModel.name);
      expect(json["secondary_text"], suggestionModel.description);
      expect(json["latitude"], suggestionModel.latitude);
      expect(json["longitude"], suggestionModel.longitude);
    });
  });
}
