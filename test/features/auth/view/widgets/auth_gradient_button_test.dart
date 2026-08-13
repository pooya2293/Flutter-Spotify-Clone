import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the button text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthGradientButton(buttonText: 'Sign up', onTap: () {}),
        ),
      ),
    );

    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('calls onTap when pressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthGradientButton(buttonText: 'Sign up', onTap: () => taps++),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));

    expect(taps, 1);
  });

  testWidgets('paints a gradient background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthGradientButton(buttonText: 'Sign up', onTap: () {}),
        ),
      ),
    );

    final decoration =
        tester.widget<Container>(find.byType(Container)).decoration
            as BoxDecoration;

    expect(decoration.gradient, isA<LinearGradient>());
  });
}
