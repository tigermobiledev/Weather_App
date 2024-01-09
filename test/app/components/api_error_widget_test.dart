import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/app/components/api_error_widget.dart';
import 'package:weather_app/app/components/custom_button.dart';

import '../../widget_test_utils.dart';

void main() {
  group('ApiErrorWidget', () {
    testWidgets('should render', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          const ApiErrorWidget(
            message: 'This is some text',
            retryAction: null,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsNWidgets(2));
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('This is some text'), findsOneWidget);
    });

    testWidgets('should update hasTapped after tap',
        (WidgetTester tester) async {
      var hasTapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          ApiErrorWidget(
            message: 'This is some text',
            retryAction: () {
              hasTapped = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomButton));

      await tester.pumpAndSettle();

      expect(hasTapped, true);
    });
  });
}
