import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        ServerConstant.resolve('/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final resBodyMap = _decodeBody(response.body);
      if (response.statusCode != 201) {
        return Left(AppFailure(_errorMessage(resBodyMap, 'Failed to sign up')));
      }

      return Right(UserModel.fromMap(resBodyMap));
    } catch (e, st) {
      debugPrint('signup failed: $e\n$st');
      return Left(AppFailure());
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        ServerConstant.resolve('/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final resBodyMap = _decodeBody(response.body);
      if (response.statusCode != 200) {
        return Left(AppFailure(_errorMessage(resBodyMap, 'Failed to login')));
      }
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e, st) {
      debugPrint('login failed: $e\n$st');
      return Left(AppFailure());
    }
  }

  Map<String, dynamic> _decodeBody(String body) {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  String _errorMessage(Map<String, dynamic> body, String fallback) {
    final detail = body['detail'];
    return detail is String && detail.isNotEmpty ? detail : fallback;
  }
}
