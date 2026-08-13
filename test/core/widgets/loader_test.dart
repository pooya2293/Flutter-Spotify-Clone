import 'package:client/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Loader shows a centered progress indicator', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Loader()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(Center),
      ),
      findsOneWidget,
    );
  });
}
