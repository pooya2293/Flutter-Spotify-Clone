import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakeAuthRemoteRepository extends AuthRemoteRepository {
  _FakeAuthRemoteRepository(this._result);

  final Either<AppFailure, UserModel> _result;
  Map<String, String>? lastSignupArgs;

  @override
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    lastSignupArgs = {'name': name, 'email': email, 'password': password};
    return _result;
  }
}

void main() {
  final user = UserModel(name: 'Pouriya', email: 'p@example.com', id: 'u-1');

  ProviderContainer containerWith(_FakeAuthRemoteRepository repository) {
    return ProviderContainer.test(
      overrides: [authRemoteRepositoryProvider.overrideWithValue(repository)],
    );
  }

  test('initial state is null', () {
    final container = containerWith(_FakeAuthRemoteRepository(Right(user)));

    expect(container.read(authViewModelProvider), isNull);
  });

  test('signUpUser forwards the credentials to the repository', () async {
    final repository = _FakeAuthRemoteRepository(Right(user));
    final container = containerWith(repository);

    await container
        .read(authViewModelProvider.notifier)
        .signUpUser(
          name: 'Pouriya',
          email: 'p@example.com',
          password: 'secret',
        );

    expect(repository.lastSignupArgs, {
      'name': 'Pouriya',
      'email': 'p@example.com',
      'password': 'secret',
    });
  });

  test('signUpUser emits loading then data on success', () async {
    final container = containerWith(_FakeAuthRemoteRepository(Right(user)));
    final states = <AsyncValue<UserModel>?>[];
    container.listen(
      authViewModelProvider,
      (_, next) => states.add(next),
      fireImmediately: true,
    );

    await container
        .read(authViewModelProvider.notifier)
        .signUpUser(
          name: 'Pouriya',
          email: 'p@example.com',
          password: 'secret',
        );

    expect(states.first, isNull);
    expect(states[1], isA<AsyncLoading<UserModel>>());
    expect(states.last, AsyncData(user));
  });

  test('signUpUser emits the failure message as the error on failure',
      () async {
    final container = containerWith(
      _FakeAuthRemoteRepository(Left(AppFailure('User already exists'))),
    );

    await container
        .read(authViewModelProvider.notifier)
        .signUpUser(
          name: 'Pouriya',
          email: 'p@example.com',
          password: 'secret',
        );

    final state = container.read(authViewModelProvider);
    expect(state, isA<AsyncError<UserModel>>());
    expect(state!.error, 'User already exists');
  });
}
