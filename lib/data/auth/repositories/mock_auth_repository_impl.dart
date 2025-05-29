import 'dart:async';

import 'package:time_optimizer/domain/auth/entities/user_entity.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  final StreamController<UserEntity> _userController = StreamController<UserEntity>.broadcast();
  UserEntity _currentUser = UserEntity.empty;

  MockAuthRepositoryImpl() {
    // Emit initial user state (could be fetched from a local store like Hive in a real scenario)
    _userController.add(_currentUser);
  }

  @override
  Stream<UserEntity> get user => _userController.stream;

  @override
  UserEntity? get currentUser => _currentUser.isNotEmpty ? _currentUser : null;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com') { // Simulate existing user
      throw Exception('User already exists with this email.');
    }
    _currentUser = UserEntity(id: 'mock_user_id_signup', email: email, name: name ?? 'Mock User');
    _userController.add(_currentUser);
    // print('MockAuth: Signed up user: $_currentUser');
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'user@example.com' && password == 'password') {
      _currentUser = const UserEntity(id: 'mock_user_id_login', email: 'user@example.com', name: 'Mock User');
      _userController.add(_currentUser);
      // print('MockAuth: Logged in user: $_currentUser');
    } else {
      throw Exception('Invalid email or password.');
    }
  }

  @override
  Future<void> logOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserEntity.empty;
    _userController.add(_currentUser);
    // print('MockAuth: Logged out');
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // print('MockAuth: Password reset email sent to $email (simulated)');
    // In a real scenario, this would interact with a backend service.
  }

  // Dispose method to close the stream controller when the repository is no longer needed.
  // This might be called from your DI setup if it supports disposal.
  void dispose() {
    _userController.close();
  }
}
