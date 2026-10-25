import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(
      currentUserProvider.notifier,
    ); //with GPT i change this line
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print('val: $val');
  }

  Future<void> logInUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => await _loginSuccsess(r),
    };
    print('val: $val');
  }

  Future<AsyncValue<UserModel>> _loginSuccsess(UserModel user) async {
    await _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    state = AsyncValue.data(user);
    return state!;
  }

  Future<UserModel?> getData() async {
    final token = _authLocalRepository.getToken();

    debugPrint('SAVED TOKEN EXISTS: ${token != null && token.isNotEmpty}');

    // No saved token: user is logged out.
    if (token == null || token.isEmpty) {
      state = null;
      _currentUserNotifier.state = null;
      debugPrint('NO TOKEN: USER IS LOGGED OUT');
      return null;
    }

    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.getCurrentUserData(token);

    debugPrint('GET USER RESULT: $res');

    if (!ref.mounted) {
      return null;
    }

    return switch (res) {
      Left(value: final l) => _handleGetDataError(l.message),
      Right(value: final r) => _getDataSuccess(r).value,
    };
  }

  UserModel? _handleGetDataError(String message) {
    state = AsyncValue.error(message, StackTrace.current);
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
