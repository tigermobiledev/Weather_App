import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide Response;
import 'package:location/location.dart';
import 'package:weather_app/app/components/api_error_widget.dart';
import 'package:weather_app/app/components/custom_button.dart';
import 'package:weather_app/app/components/my_widgets_animator.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';
import 'package:weather_app/app/modules/home/views/home_view.dart';
import 'package:weather_app/app/modules/home/views/widgets/weather_card.dart';
import 'package:weather_app/app/services/base_client.dart';
import 'package:weather_app/app/services/location_service.dart';
import '../../../../widget_test_utils.dart';
import 'package:mocktail/mocktail.dart';

class LocationServiceMock extends Mock implements LocationService {}

class BaseClientMock extends Mock implements BaseClient {}

void main() {
  group('HomeView', () {
    testWidgets('should render with success case', (WidgetTester tester) async {
      final locationService = LocationServiceMock();
      final baseClient = BaseClientMock();
      final LocationData mockLocationData = LocationData.fromMap({
        "latitude": 37.4219983,
        "longitude": -122.084,
        "accuracy": 20.0,
        "altitude": 0.0,
        "speed": 0.0,
        "speed_accuracy": 0.0,
        "heading": 0.0,
        "time": 0.0
      });

      final mockJson = {
        {
          "latitude": 52.52,
          "longitude": 13.419998,
          "generationtime_ms": 0.2200603485107422,
          "utc_offset_seconds": 0,
          "timezone": "GMT",
          "timezone_abbreviation": "GMT",
          "elevation": 38,
          "current_units": {
            "time": "iso8601",
            "interval": "seconds",
            "temperature_2m": "°C",
            "wind_speed_10m": "km/h",
          },
          "current": {
            "time": "2024-01-05T19:00",
            "interval": 900,
            "temperature_2m": 9,
            "wind_speed_10m": 11.4,
            "weather_code": 0,
            "relative_humidity_2m": 70,
            "is_day": 1
          },
          "hourly_units": {
            "time": "iso8601",
            "temperature_2m": "°C",
            "relative_humidity_2m": "%",
            "wind_speed_10m": "km/h"
          },
          "hourly": {
            "time": [],
            "temperature_2m": [],
            "relative_humidity_2m": [],
            "wind_speed_10m": [],
            "weather_code": [],
            "is_day": [],
          }
        }
      };

      Map<String, dynamic> mockData = {};
      for (var mapInSet in mockJson) {
        mapInSet.forEach((key, value) {
          mockData[key] = value;
        });
      }

      final mockResponse =
          Response(requestOptions: RequestOptions(path: ''), data: mockData);

      when(() => locationService.getUserLocation())
          .thenAnswer((_) async => mockLocationData);
      when(() => locationService.hasLocationPermission())
          .thenAnswer((_) async => true);
      when(() => baseClient.safeApiCall(
            any(),
            RequestType.get,
            headers: any(named: 'headers'),
            queryParameters: any(named: 'queryParameters'),
            onError: any(named: 'onError'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Future(() => mockResponse));

      Get.lazyPut<HomeController>(
        () => HomeController(
            locationService: locationService,
            placeMarks: [Placemark()],
            baseClient: baseClient),
      );

      await tester.pumpWidget(
        createWidgetForTesting(
          HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MyWidgetsAnimator), findsOneWidget);
      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.text('Sunny'), findsOneWidget);
    });

    testWidgets('should render with error case', (WidgetTester tester) async {
      final locationService = LocationServiceMock();
      final baseClient = BaseClientMock();
      final LocationData mockLocationData = LocationData.fromMap({
        "latitude": 37.4219983,
        "longitude": -122.084,
        "accuracy": 20.0,
        "altitude": 0.0,
        "speed": 0.0,
        "speed_accuracy": 0.0,
        "heading": 0.0,
        "time": 0.0
      });

      when(() => locationService.getUserLocation())
          .thenAnswer((_) async => mockLocationData);
      when(() => locationService.hasLocationPermission())
          .thenAnswer((_) async => true);
      when(() => baseClient.safeApiCall(
            any(),
            RequestType.get,
            headers: any(named: 'headers'),
            queryParameters: any(named: 'queryParameters'),
            onError: any(named: 'onError'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Future(() => null));

      Get.lazyPut<HomeController>(
        () => HomeController(
            locationService: locationService,
            placeMarks: [Placemark()],
            baseClient: baseClient),
      );
      await tester.pumpWidget(
        createWidgetForTesting(
          HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ApiErrorWidget), findsOneWidget);
      expect(find.byType(MyWidgetsAnimator), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Something went wrong! please try again later'),
          findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });
  });
}
