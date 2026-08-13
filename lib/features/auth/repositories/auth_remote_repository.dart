import 'package:client/core/failure/failure.dart';
import 'package:client/core/network/api_client.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';

class AuthRemoteRepository {
  final ApiClient _apiClient;

  AuthRemoteRepository([this._apiClient = const ApiClient()]);

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _apiClient.post(
      path: '/auth/signup',
      body: {'name': name, 'email': email, 'password': password},
      failureMessage: 'Failed to sign up',
      successStatusCode: 201,
    );
    return res.map(UserModel.fromMap);
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    final res = await _apiClient.post(
      path: '/auth/login',
      body: {'email': email, 'password': password},
      failureMessage: 'Failed to login',
    );
    return res.map(UserModel.fromMap);
  }
}
