import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/// Thin wrapper around [http] that centralises JSON encoding/decoding,
/// status code checking and failure mapping for the backend API.
class ApiClient {
  const ApiClient();

  Future<Either<AppFailure, Map<String, dynamic>>> post({
    required String path,
    required Map<String, dynamic> body,
    required String failureMessage,
    int successStatusCode = 200,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != successStatusCode) {
        return Left(AppFailure('$failureMessage: ${resBodyMap['detail']}'));
      }

      return Right(resBodyMap);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
