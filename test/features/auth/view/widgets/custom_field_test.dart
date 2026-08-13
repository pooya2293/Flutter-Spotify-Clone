import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formKey = GlobalKey<FormState>();

  Future<void> pumpField(
    WidgetTester tester,
    TextEditingController controller, {
    bool isObscureText = false,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: CustomField(
              hintText: 'Email',
              controller: controller,
              isObscureText: isObscureText,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the hint text', (tester) async {
    await pumpField(tester, TextEditingController());

    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('writes typed text into the controller', (tester) async {
    final controller = TextEditingController();
    await pumpField(tester, controller);

    await tester.enterText(find.byType(TextFormField), 'p@example.com');

    expect(controller.text, 'p@example.com');
  });

  testWidgets('validation fails with an error for blank input', (tester) async {
    await pumpField(tester, TextEditingController(text: '   '));

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Please enter Email'), findsOneWidget);
  });

  testWidgets('validation passes for non blank input', (tester) async {
    await pumpField(tester, TextEditingController(text: 'p@example.com'));

    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('Please enter Email'), findsNothing);
  });

  testWidgets('is not obscured by default and obscured when asked',
      (tester) async {
    await pumpField(tester, TextEditingController());
    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse);

    await pumpField(tester, TextEditingController(), isObscureText: true);
    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue);
  });
}
