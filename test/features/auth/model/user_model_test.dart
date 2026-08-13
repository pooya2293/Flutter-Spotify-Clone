import 'dart:convert';

import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final user = UserModel(name: 'Pouriya', email: 'p@example.com', id: 'u-1');

  group('UserModel', () {
    test('toMap serializes every field', () {
      expect(user.toMap(), {
        'name': 'Pouriya',
        'email': 'p@example.com',
        'id': 'u-1',
      });
    });

    test('fromMap reads every field', () {
      expect(UserModel.fromMap(user.toMap()), user);
    });

    test('fromMap falls back to empty strings for missing fields', () {
      final empty = UserModel.fromMap(const {});

      expect(empty.name, '');
      expect(empty.email, '');
      expect(empty.id, '');
    });

    test('fromMap ignores unknown fields', () {
      final parsed = UserModel.fromMap({
        ...user.toMap(),
        'token': 'a-jwt-token',
      });

      expect(parsed, user);
    });

    test('toJson produces decodable json', () {
      expect(jsonDecode(user.toJson()), user.toMap());
    });

    test('fromJson round trips toJson', () {
      expect(UserModel.fromJson(user.toJson()), user);
    });

    test('fromJson throws on malformed json', () {
      expect(() => UserModel.fromJson('not json'), throwsFormatException);
    });

    test('copyWith replaces only the given fields', () {
      final copy = user.copyWith(email: 'new@example.com');

      expect(copy.email, 'new@example.com');
      expect(copy.name, user.name);
      expect(copy.id, user.id);
    });

    test('copyWith without arguments keeps every value', () {
      expect(user.copyWith(), user);
    });

    test('equality compares by value', () {
      expect(user, UserModel.fromMap(user.toMap()));
      expect(user, isNot(user.copyWith(id: 'u-2')));
    });

    test('hashCode is equal for equal values', () {
      expect(user.hashCode, UserModel.fromMap(user.toMap()).hashCode);
    });

    test('toString includes every field', () {
      expect(
        user.toString(),
        'UserModel(name: Pouriya, email: p@example.com, id: u-1)',
      );
    });
  });
}
