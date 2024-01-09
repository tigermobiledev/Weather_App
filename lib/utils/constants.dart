class Constants {
  // google api key
  static const googleApiKey = 'YOUR_API_KEY';
  // api urls
  static const baseUrl = 'https://api.open-meteo.com/v1';
  static const currentWeatherApiUrl = '$baseUrl/forecast';
  static const forecastWeatherApiUrl = '$baseUrl/forecast.json';
  // Google Places API
  static const autoCompleteApiUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String placeDetails =
      'https://maps.googleapis.com/maps/api/place/details/json';
  // api fields

  // assets
  static const logo = 'assets/images/app_icon.png';
  static const welcome = 'assets/images/welcome.png';
  static const world = 'assets/images/world.png';
  static const world2 = 'assets/images/world2.png';
  static const noData = 'assets/images/no_data.png';
  static const search = 'assets/vectors/search.svg';
  static const language = 'assets/vectors/language.svg';
  static const settings = 'assets/vectors/settings.svg';
  static const category = 'assets/vectors/category.svg';
  static const downArrow = 'assets/vectors/down_arrow.svg';
  static const wind = 'assets/vectors/wind.svg';
  static const pressure = 'assets/vectors/pressure.svg';

  static const weatherAnimation = 'assets/data/weather_animation.json';
}
