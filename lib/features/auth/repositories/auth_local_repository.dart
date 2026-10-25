import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      final saved = await _sharedPreferences.setString('x-auth-token', token);

      debugPrint('TOKEN SAVE RESULT: $saved');
      debugPrint('TOKEN EXISTS AFTER SAVE: ${getToken()?.isNotEmpty == true}');
    } else {
      debugPrint('TOKEN SAVE SKIPPED: token is null or empty');
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
