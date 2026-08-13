import 'dart:async';
import 'dart:convert';

import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

AuthRemoteRepository _repository(
  Future<http.Response> Function(http.Request) handler, {
  Duration? timeout,
}) {
  return AuthRemoteRepository(client: MockClient(handler), timeout: timeout);
}

String _messageOf(Either<AppFailure, Object?> res) => switch (res) {
  Left(value: final failure) => failure.message,
  Right(value: final value) => fail('Expected a failure but got $value'),
};

UserModel _userOf(Either<AppFailure, UserModel> res) => switch (res) {
  Left(value: final failure) => fail('Expected a user but got $failure'),
  Right(value: final user) => user,
};

void main() {
  group('signup', () {
    test('returns the user on 201', () async {
      final res = await _repository(
        (_) async => http.Response(
          jsonEncode({'id': '1', 'name': 'Pouriya', 'email': 'a@b.com'}),
          201,
        ),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_userOf(res).email, 'a@b.com');
    });

    test('surfaces the server detail on an error status', () async {
      final res = await _repository(
        (_) async =>
            http.Response(jsonEncode({'detail': 'Email already taken'}), 409),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('Email already taken'));
    });

    test('falls back to the status code for a non-JSON error body', () async {
      final res = await _repository(
        (_) async => http.Response('<html>Bad Gateway</html>', 502),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('502'));
    });

    test('reports an invalid response when the payload is not JSON', () async {
      final res = await _repository(
        (_) async => http.Response('not json', 201),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('invalid response'));
    });

    test('reports an invalid response when a user field is missing', () async {
      final res = await _repository(
        (_) async => http.Response(jsonEncode({'id': '1'}), 201),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('invalid response'));
    });

    test('reports a connection failure', () async {
      final res = await _repository(
        (_) async => throw http.ClientException('Connection refused'),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('Could not reach the server'));
    });

    test('reports a timeout', () async {
      final res = await _repository(
        (_) => Completer<http.Response>().future,
        timeout: const Duration(milliseconds: 10),
      ).signup(name: 'Pouriya', email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('took too long'));
    });
  });

  group('login', () {
    test('returns the user on 200', () async {
      final res = await _repository(
        (_) async => http.Response(
          jsonEncode({'id': '1', 'name': 'Pouriya', 'email': 'a@b.com'}),
          200,
        ),
      ).login(email: 'a@b.com', password: 'pw');

      expect(_userOf(res).name, 'Pouriya');
    });

    test('surfaces the server detail on 401', () async {
      final res = await _repository(
        (_) async =>
            http.Response(jsonEncode({'detail': 'Invalid credentials'}), 401),
      ).login(email: 'a@b.com', password: 'pw');

      expect(_messageOf(res), contains('Invalid credentials'));
    });
  });

  test('describeError uses the AppFailure message', () {
    expect(describeError(AppFailure('boom')), 'boom');
    expect(describeError(null), isNotEmpty);
  });
}
