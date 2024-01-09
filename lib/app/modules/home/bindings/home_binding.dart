import 'package:get/get.dart';
import 'package:weather_app/app/services/base_client.dart';
import 'package:weather_app/app/services/location_service.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final baseClient = BaseClient();
    Get.lazyPut<HomeController>(
      () => HomeController(
          locationService: LocationService(),
          placeMarks: [],
          baseClient: baseClient),
    );
  }
}
