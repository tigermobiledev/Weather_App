import 'package:get/get.dart';

import 'en_US/en_us_translation.dart';

class LocalizationService extends Translations {
  // prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
      };
}
