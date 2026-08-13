import 'package:flutter/foundation.dart';

class ServerConstant {
  /// Backend base URL, overridable at build time with
  /// `--dart-define=SERVER_URL=https://api.example.com`.
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Cleartext HTTP is only tolerated for local development.
  static Uri resolve(String path) {
    final uri = Uri.parse('$serverUrl$path');
    if (!kDebugMode && uri.scheme != 'https') {
      throw StateError(
        'Insecure server URL "$serverUrl": HTTPS is required outside debug '
        'builds. Pass --dart-define=SERVER_URL=https://...',
      );
    }
    return uri;
  }
}
