import 'dart:developer' as developer;
import 'dart:ui';

import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final defaultOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    developer.log(
      'Uncaught framework error',
      name: 'client',
      error: details.exception,
      stackTrace: details.stack,
    );
    defaultOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    developer.log(
      'Uncaught platform error',
      name: 'client',
      error: error,
      stackTrace: stack,
    );
    // Let the platform's default handler run too instead of swallowing it.
    return false;
  };

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignupPage(),
    );
  }
}
