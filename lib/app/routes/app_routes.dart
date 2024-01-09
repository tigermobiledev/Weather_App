part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const welcome = _Paths.welcome;
  static const home = _Paths.home;
  static const weather = _Paths.weather;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const home = '/home';
  static const weather = '/weather';
}
