import 'parsers.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.city,
    this.state,
    this.avatarUrl,
    this.createdAt,
  });

  final int id;
  final String name;
  final String email;
  final String? city;
  final String? state;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? 'Usuário',
      email: json['email']?.toString() ?? '',
      city: json['city']?.toString() ?? json['cidade']?.toString(),
      state: json['state']?.toString() ?? json['uf']?.toString(),
      avatarUrl: json['avatar']?.toString(),
      createdAt: parseDate(json['created_at']),
    );
  }
}
