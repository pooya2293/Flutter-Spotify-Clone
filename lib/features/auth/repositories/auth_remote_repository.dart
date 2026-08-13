import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  AuthRemoteRepository({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 15);

  final http.Client _client;
  final Duration _timeout;

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _postUser(
      path: '/auth/signup',
      action: 'sign up',
      expectedStatusCode: 201,
      body: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) {
    return _postUser(
      path: '/auth/login',
      action: 'login',
      expectedStatusCode: 200,
      body: {'email': email, 'password': password},
    );
  }

  Future<Either<AppFailure, UserModel>> _postUser({
    required String path,
    required String action,
    required int expectedStatusCode,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ServerConstant.serverUrl}$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode != expectedStatusCode) {
        return Left(
          AppFailure('Failed to $action: ${_errorMessage(response)}'),
        );
      }

      return Right(UserModel.fromMap(_decodeBody(response)));
    } on http.ClientException catch (e, st) {
      return Left(
        AppFailure(
          'Could not reach the server. Check your connection and try again.',
          e,
          st,
        ),
      );
    } on TimeoutException catch (e, st) {
      return Left(
        AppFailure(
          'Failed to $action: the server took too long to respond.',
          e,
          st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        AppFailure(
          'Failed to $action: the server returned an invalid response.',
          e,
          st,
        ),
      );
    } catch (e, st) {
      developer.log(
        'Unexpected error while calling $path',
        name: 'AuthRemoteRepository',
        error: e,
        stackTrace: st,
      );
      return Left(AppFailure('Failed to $action: ${e.runtimeType}.', e, st));
    }
  }

  /// Decodes a JSON object body, throwing a [FormatException] when the server
  /// answers with something that is not a JSON object.
  Map<String, dynamic> _decodeBody(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'Expected a JSON object but got ${decoded.runtimeType}',
        response.body,
      );
    }
    return decoded;
  }

  /// Best-effort extraction of the server's error message. Error responses are
  /// not guaranteed to be JSON (proxies and crashes return HTML or nothing), so
  /// this never throws and falls back to the status code.
  String _errorMessage(http.Response response) {
    try {
      final detail = _decodeBody(response)['detail'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        return detail.toString();
      }
    } on FormatException {
      // Fall through to the status-code based message below.
    }
    return 'server responded with status ${response.statusCode}';
  }
}
