import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = _toState(
      await _authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = _toState(
      await _authRemoteRepository.login(email: email, password: password),
    );
  }

  AsyncValue<UserModel> _toState(Either<AppFailure, UserModel> res) {
    return switch (res) {
      Left(value: final failure) => AsyncValue.error(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
      Right(value: final user) => AsyncValue.data(user),
    };
  }
}
