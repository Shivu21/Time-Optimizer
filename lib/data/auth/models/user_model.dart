import 'package:hive/hive.dart';
import 'package:time_optimizer/domain/auth/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? photoUrl;

  UserModel({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
  });

  /// Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }

  /// Create a UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
    );
  }

  /// Empty user
  static final empty = UserModel(id: '');

  /// Check if user is empty
  bool get isEmpty => id.isEmpty;

  /// Check if user is not empty
  bool get isNotEmpty => id.isNotEmpty;
}
