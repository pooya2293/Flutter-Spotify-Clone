import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/main.dart';

void main() {
  setUp(() {
    // The auth form is taller than the default 800x600 test surface.
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views
        .first;
    view.physicalSize = const Size(1080, 1920);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  });

  testWidgets('shows the signup form on launch', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(SignupPage), findsOneWidget);
    expect(find.text('Sign Up.'), findsOneWidget);
  });

  testWidgets('validates empty fields instead of calling the server', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign up'));
    await tester.pump();

    expect(find.text('Please enter Email'), findsOneWidget);
    expect(find.text('Please enter Password'), findsOneWidget);
  });
}
