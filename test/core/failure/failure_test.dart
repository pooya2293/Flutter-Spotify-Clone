import 'package:client/core/failure/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFailure', () {
    test('uses a default message when none is given', () {
      expect(
        AppFailure().message,
        'Sorry, something went wrong. Please try again later.',
      );
    });

    test('keeps the provided message', () {
      expect(AppFailure('boom').message, 'boom');
    });

    test('toString includes the message', () {
      expect(AppFailure('boom').toString(), 'AppFailure(message: boom)');
    });
  });
}
