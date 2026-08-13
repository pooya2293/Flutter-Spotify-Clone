import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpLoginPage(WidgetTester tester) {
    return tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LogInPage())),
    );
  }

  testWidgets('renders the email and password fields', (tester) async {
    await pumpLoginPage(tester);

    expect(find.text('Sign In.'), findsOneWidget);
    expect(find.byType(CustomField), findsNWidgets(2));
    expect(find.byType(AuthGradientButton), findsOneWidget);
  });

  testWidgets('validates the empty form', (tester) async {
    await pumpLoginPage(tester);

    tester
        .state<FormState>(find.byType(Form))
        .validate();
    await tester.pump();

    expect(find.text('Please enter Email'), findsOneWidget);
    expect(find.text('Please enter Password'), findsOneWidget);
  });

  testWidgets('the sign up link opens the signup page', (tester) async {
    await pumpLoginPage(tester);

    await tester.tap(find.byType(RichText).last);
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);
  });
}
