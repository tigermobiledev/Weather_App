import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:location/location.dart';
import 'package:weather_app/app/data/models/address_model.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';
import '../views/widgets/location_dialog.dart';
import 'package:geocoding/geocoding.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  final LocationService locationService;
  final List<Placemark> placeMarks;
  final BaseClient baseClient;

  HomeController(
      {required this.locationService,
      required this.placeMarks,
      required this.baseClient});
  // get the current language code

  // hold current weather data
  late WeatherModel currentWeather;
  // hold the search address
  final searchAddress = RxList<SuggestionModel>([]);
  // hold the weather around the world
  List<WeatherModel> weatherAroundTheWorld = [];

  final selectedAddress = Rx<SuggestionModel?>(null);

  // for update
  final dotIndicatorsId = 'DotIndicators';
  final themeId = 'Theme';

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;

  // for app theme
  var isLightTheme = true /*MySharedPref.getThemeIsLight()*/;

  // for weather slider and dot indicator
  var activeIndex = 1;

  @override
  void onInit() async {
    if (!await locationService.hasLocationPermission()) {
      Get.dialog(const LocationDialog());
    } else {
      getUserLocation();
    }
    super.onInit();
  }

  /// get the user location
  Future<void> getUserLocation() async {
    var locationData = await locationService.getUserLocation();
    if (locationData != null) {
      await getCurrentWeather(locationData);
    }
  }

  /// get home screen data (sliders, brands, and cars)
  Future<void> getCurrentWeather(LocationData location) async {
    if (location.latitude == null || location.longitude == null) {
      return;
    }
    if (placeMarks.isEmpty) {
      List<Placemark> marks = await placemarkFromCoordinates(
          location.latitude!, location.longitude!);
      placeMarks.addAll(marks);
    }

    String address = '';
    String country = '';
    if (placeMarks.isNotEmpty) {
      Placemark firstPlaceMark = placeMarks.first;
      country = firstPlaceMark.country ?? '';
      address =
          "${firstPlaceMark.street}, ${firstPlaceMark.administrativeArea}";
    }

    final response = await baseClient.safeApiCall(
      Constants.currentWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'current':
            'temperature_2m,wind_speed_10m,relative_humidity_2m,weather_code,is_day',
        'hourly':
            'temperature_2m,wind_speed_10m,relative_humidity_2m,weather_code,is_day',
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
    if (response != null && response is Response) {
      Map<String, dynamic> data = response.data;
      data['name'] = address;
      data['country'] = country;
      try {
        currentWeather = WeatherModel.fromJson(data);
        apiCallStatus = ApiCallStatus.success;
      } catch (e) {
        apiCallStatus = ApiCallStatus.error;
      }
      update();
    } else {
      apiCallStatus = ApiCallStatus.error;
      update();
    }
  }

  /// when the user slide the weather card
  onCardSlided(index, reason) {
    activeIndex = index;
    update([dotIndicatorsId]);
  }

  /// when the user press on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update([themeId]);
  }

  /// when the user press on change language icon
  onChangeLanguagePressed() async {}

  /// when the user select address from search
  onAddressSelected(SuggestionModel suggestionModel) async {
    SuggestionModel? model = await _getLatLng(suggestionModel);
    if (model != null) {
      placeMarks.clear();
      selectedAddress.value = model;
      searchAddress.clear();
      await getCurrentWeather(LocationData.fromMap({
        'latitude': model.latitude,
        'longitude': model.longitude,
      }));
    } else {
      selectedAddress.value = null;
    }
    update();
  }

  /// when the user press on clear search address icon
  clearSearchAddress() {
    searchAddress.clear();
    selectedAddress.value = null;
    update();
  }

  /// Search for addresses using google places api
  Future<List<SuggestionModel>> fetchSuggestionAddresses(String text) async {
    if (text.length < 3) return [];
    searchAddress.clear();
    final response = await baseClient.safeApiCall(
      Constants.autoCompleteApiUrl,
      RequestType.get,
      queryParameters: {
        'input': text,
        'radius': 5000,
        'sensor': true,
        'key': Constants.googleApiKey,
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
    if (response != null && response is Response) {
      try {
        Map<String, dynamic> data = response.data;
        List<dynamic> list = data['predictions'];
        final suggestions = list.map((e) {
          final map = e['structured_formatting'];
          map['place_id'] = e['place_id'];
          SuggestionModel addressModel = SuggestionModel.fromJson(map);
          return addressModel;
        }).toList();
        searchAddress.addAll(suggestions);
        apiCallStatus = ApiCallStatus.success;
        update();
        return suggestions;
      } catch (e) {
        apiCallStatus = ApiCallStatus.error;
        update();
      }
    }
    return [];
  }

  /// get the latitude and longitude of the selected address
  Future<SuggestionModel?> _getLatLng(SuggestionModel suggestionModel) async {
    SuggestionModel? newSuggestion;
    final response = await baseClient.safeApiCall(
      Constants.placeDetails,
      RequestType.get,
      queryParameters: {
        'placeid': suggestionModel.placeId,
        'key': Constants.googleApiKey,
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
    if (response == null) {
      return null;
    }
    final data = response.data;
    try {
      Map<String, dynamic> result = data['result']['geometry']['location'];
      double lat = result['lat'];
      double lng = result['lng'];
      suggestionModel.latitude = lat;
      suggestionModel.longitude = lng;
      newSuggestion = suggestionModel;
    } catch (e) {
      return null;
    }
    return newSuggestion;
  }
}
