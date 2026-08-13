import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const user = {'name': 'Pouriya', 'email': 'p@example.com', 'id': 'u-1'};

  AuthRemoteRepository repositoryReturning(
    http.Response response, {
    void Function(http.Request request)? onRequest,
  }) {
    return AuthRemoteRepository(
      client: MockClient((request) async {
        onRequest?.call(request);
        return response;
      }),
    );
  }

  group('signup', () {
    test('posts name, email and password as json to /auth/signup', () async {
      http.Request? sent;
      final repository = repositoryReturning(
        http.Response(jsonEncode(user), 201),
        onRequest: (request) => sent = request,
      );

      await repository.signup(
        name: 'Pouriya',
        email: 'p@example.com',
        password: 'secret',
      );

      expect(sent!.method, 'POST');
      expect(
        sent!.url,
        Uri.parse('${ServerConstant.serverUrl}/auth/signup'),
      );
      expect(sent!.headers['Content-Type'], contains('application/json'));
      expect(jsonDecode(sent!.body), {
        'name': 'Pouriya',
        'email': 'p@example.com',
        'password': 'secret',
      });
    });

    test('returns the created user on 201', () async {
      final repository = repositoryReturning(
        http.Response(jsonEncode(user), 201),
      );

      final res = await repository.signup(
        name: 'Pouriya',
        email: 'p@example.com',
        password: 'secret',
      );

      expect(res, isA<Right<AppFailure, UserModel>>());
      expect(res.getRight().getOrNull(), UserModel.fromMap(user));
    });

    test('returns a failure carrying the server detail on error status',
        () async {
      final repository = repositoryReturning(
        http.Response(jsonEncode({'detail': 'User already exists'}), 400),
      );

      final res = await repository.signup(
        name: 'Pouriya',
        email: 'p@example.com',
        password: 'secret',
      );

      expect(
        res.getLeft().getOrNull()!.message,
        'Failed to sign up: User already exists',
      );
    });

    test('returns a failure when the response body is not json', () async {
      final repository = repositoryReturning(
        http.Response('<html>502 Bad Gateway</html>', 502),
      );

      final res = await repository.signup(
        name: 'Pouriya',
        email: 'p@example.com',
        password: 'secret',
      );

      expect(res, isA<Left<AppFailure, UserModel>>());
    });

    test('returns a failure when the request throws', () async {
      final repository = AuthRemoteRepository(
        client: MockClient((_) async => throw http.ClientException('offline')),
      );

      final res = await repository.signup(
        name: 'Pouriya',
        email: 'p@example.com',
        password: 'secret',
      );

      expect(res.getLeft().getOrNull()!.message, contains('offline'));
    });
  });

  group('login', () {
    test('posts email and password as json to /auth/login', () async {
      http.Request? sent;
      final repository = repositoryReturning(
        http.Response(jsonEncode(user), 200),
        onRequest: (request) => sent = request,
      );

      await repository.login(email: 'p@example.com', password: 'secret');

      expect(sent!.method, 'POST');
      expect(sent!.url, Uri.parse('${ServerConstant.serverUrl}/auth/login'));
      expect(jsonDecode(sent!.body), {
        'email': 'p@example.com',
        'password': 'secret',
      });
    });

    test('returns the logged in user on 200', () async {
      final repository = repositoryReturning(
        http.Response(jsonEncode(user), 200),
      );

      final res = await repository.login(
        email: 'p@example.com',
        password: 'secret',
      );

      expect(res.getRight().getOrNull(), UserModel.fromMap(user));
    });

    test('treats 201 as a failure', () async {
      final repository = repositoryReturning(
        http.Response(jsonEncode({'detail': 'unexpected'}), 201),
      );

      final res = await repository.login(
        email: 'p@example.com',
        password: 'secret',
      );

      expect(
        res.getLeft().getOrNull()!.message,
        'Failed to login: unexpected',
      );
    });

    test('returns a failure carrying the server detail on error status',
        () async {
      final repository = repositoryReturning(
        http.Response(jsonEncode({'detail': 'Invalid credentials'}), 401),
      );

      final res = await repository.login(
        email: 'p@example.com',
        password: 'wrong',
      );

      expect(
        res.getLeft().getOrNull()!.message,
        'Failed to login: Invalid credentials',
      );
    });

    test('returns a failure when the request throws', () async {
      final repository = AuthRemoteRepository(
        client: MockClient((_) async => throw http.ClientException('offline')),
      );

      final res = await repository.login(
        email: 'p@example.com',
        password: 'secret',
      );

      expect(res.getLeft().getOrNull()!.message, contains('offline'));
    });
  });
}
