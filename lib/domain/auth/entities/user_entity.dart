import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
  });

  // A factory constructor for creating an empty/unauthenticated user instance
  static const empty = UserEntity(id: '');

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [id, email, name, photoUrl];
}
