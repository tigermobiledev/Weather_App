import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

WidgetTester setUpScreenSize(WidgetTester tester) {
  const width = 800;
  const height = 1500;
  tester.view.devicePixelRatio = 2.625;
  tester.platformDispatcher.textScaleFactorTestValue = 1.1;
  final dpi = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(width * dpi, height * dpi);

  return tester;
}

Widget createWidgetForTesting(Widget child, {bool withLocalization = false}) {
  return ScreenUtilInit(
    designSize: const Size(800, 1500),
    minTextAdapt: true,
    splitScreenMode: true,
    useInheritedMediaQuery: true,
    rebuildFactor: (old, data) => true,
    child: GetMaterialApp(
      locale: const Locale('en'),
      home: DefaultAssetBundle(
        bundle: PlatformAssetBundle(),
        child: Material(child: child),
      ),
    ),
  );
}
