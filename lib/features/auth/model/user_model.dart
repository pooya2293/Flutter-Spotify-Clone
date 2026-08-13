import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String email;
  final String id;
  UserModel({required this.name, required this.email, required this.id});

  UserModel copyWith({String? name, String? email, String? id}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email, 'id': id};
  }

  /// Throws a [FormatException] when a field is missing or not a string, so a
  /// malformed payload surfaces as an error instead of an empty user.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: _readString(map, 'name'),
      email: _readString(map, 'email'),
      id: _readString(map, 'id'),
    );
  }

  static String _readString(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Missing or invalid "$key" in user payload');
    }
    return value;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) {
    final decoded = json.decode(source);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('Expected a JSON object for a user', source);
    }
    return UserModel.fromMap(decoded);
  }

  @override
  String toString() => 'UserModel(name: $name, email: $email, id: $id)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ id.hashCode;
}
