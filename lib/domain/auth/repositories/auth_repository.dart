import 'package:time_optimizer/domain/auth/entities/user_entity.dart';

/// Abstract repository for authentication.
///
/// This defines the contract for authentication operations that the domain layer
/// expects. Implementations will reside in the data layer.
abstract class AuthRepository {
  /// Stream of [UserEntity] which will emit the current user when the
  /// authentication state changes. Emits [UserEntity.empty] if the user is
  /// not authenticated.
  Stream<UserEntity> get user;

  /// Signs up a new user with the given [email] and [password].
  /// Throws an exception if sign up fails.
  Future<void> signUp({
    required String email,
    required String password,
    String? name, // Optional: if you collect name at signup
  });

  /// Logs in an existing user with the given [email] and [password].
  /// Throws an exception if login fails.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Logs out the current user.
  Future<void> logOut();

  /// Sends a password reset email to the given [email].
  Future<void> sendPasswordResetEmail({required String email});

  /// Attempts to get the current signed-in user synchronously.
  /// Returns null if no user is signed in or if the user status is not yet determined.
  /// This can be useful for initial app load to quickly check auth status
  /// without waiting for the stream, but the `user` stream is the source of truth.
  UserEntity? get currentUser;
}
