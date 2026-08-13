import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the signup page with the dark theme', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(SignupPage), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme,
      AppTheme.darkThemeMode,
    );
    expect(
      Theme.of(tester.element(find.byType(SignupPage))).scaffoldBackgroundColor,
      Palette.backgroundColor,
    );
  });
}
