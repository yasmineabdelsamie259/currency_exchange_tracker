import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poundwise/core/design_system/theme/app_theme.dart';
import 'package:poundwise/features/splash/presentation/pages/poundwise_splash_page.dart';

void main() {
  testWidgets(
    'shows the branded splash then finishes after its launch duration',
    (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: PoundwiseSplashPage(
            duration: const Duration(milliseconds: 800),
            onFinished: () => completed = true,
          ),
        ),
      );

      expect(find.text('poundwise'), findsOneWidget);
      expect(find.text('Exchange rates, made clear'), findsOneWidget);
      expect(find.bySemanticsLabel('Loading exchange rates'), findsOneWidget);
      expect(completed, isFalse);

      await tester.pump(const Duration(milliseconds: 800));
      expect(completed, isTrue);
    },
  );
}
