import 'dart:async';

import 'package:client/core/failure/failure.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakeAuthRemoteRepository extends AuthRemoteRepository {
  _FakeAuthRemoteRepository(this._result);

  final Either<AppFailure, UserModel> _result;
  final pending = Completer<void>();
  var signupCalls = 0;
  var blockUntilCompleted = false;

  @override
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    signupCalls++;
    if (blockUntilCompleted) await pending.future;
    return _result;
  }
}

void main() {
  final user = UserModel(name: 'Pouriya', email: 'p@example.com', id: 'u-1');

  Future<void> pumpSignupPage(
    WidgetTester tester,
    AuthRemoteRepository repository,
  ) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [authRemoteRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SignupPage()),
      ),
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(find.byType(CustomField).at(0), 'Pouriya');
    await tester.enterText(find.byType(CustomField).at(1), 'p@example.com');
    await tester.enterText(find.byType(CustomField).at(2), 'secret');
  }

  testWidgets('renders three fields and the signup button', (tester) async {
    await pumpSignupPage(tester, _FakeAuthRemoteRepository(Right(user)));

    expect(find.text('Sign Up.'), findsOneWidget);
    expect(find.byType(CustomField), findsNWidgets(3));
    expect(find.byType(AuthGradientButton), findsOneWidget);
  });

  testWidgets('does not call the repository when the form is empty', (
    tester,
  ) async {
    final repository = _FakeAuthRemoteRepository(Right(user));
    await pumpSignupPage(tester, repository);

    await tester.tap(find.byType(AuthGradientButton));
    await tester.pumpAndSettle();

    expect(repository.signupCalls, 0);
    expect(find.text('Please enter Name'), findsOneWidget);
  });

  testWidgets('shows a loader while signing up', (tester) async {
    final repository = _FakeAuthRemoteRepository(Right(user))
      ..blockUntilCompleted = true;
    await pumpSignupPage(tester, repository);
    await fillForm(tester);

    await tester.tap(find.byType(AuthGradientButton));
    await tester.pump();

    expect(find.byType(Loader), findsOneWidget);

    repository.pending.complete();
    await tester.pumpAndSettle();

    expect(find.byType(Loader), findsNothing);
  });

  testWidgets('navigates to the login page on success', (tester) async {
    await pumpSignupPage(tester, _FakeAuthRemoteRepository(Right(user)));
    await fillForm(tester);

    await tester.tap(find.byType(AuthGradientButton));
    await tester.pumpAndSettle();

    expect(find.text('User created successfully'), findsOneWidget);
    expect(find.byType(LogInPage), findsOneWidget);
  });

  testWidgets('shows the failure message in a snack bar on error', (
    tester,
  ) async {
    await pumpSignupPage(
      tester,
      _FakeAuthRemoteRepository(Left(AppFailure('User already exists'))),
    );
    await fillForm(tester);

    await tester.tap(find.byType(AuthGradientButton));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);
    expect(find.text('User already exists'), findsOneWidget);
  });

  testWidgets('the sign in link opens the login page', (tester) async {
    await pumpSignupPage(tester, _FakeAuthRemoteRepository(Right(user)));

    await tester.tap(find.byType(RichText).last);
    await tester.pumpAndSettle();

    expect(find.byType(LogInPage), findsOneWidget);
  });
}
