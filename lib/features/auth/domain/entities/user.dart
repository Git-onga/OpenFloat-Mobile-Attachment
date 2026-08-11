import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role; // 'client' or 'provider'
  final String? profileImage;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'client',
    this.profileImage,
    required this.createdAt,
  });

  bool get isProvider => role == 'provider';
  bool get isClient => role == 'client';

  @override
  List<Object?> get props => [id, email, name, role, profileImage, createdAt];
}
