import 'dart:async';

import 'package:hive/hive.dart';
import 'package:time_optimizer/data/auth/models/user_model.dart';
import 'package:time_optimizer/domain/auth/entities/user_entity.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';

class HiveAuthRepositoryImpl implements AuthRepository {
  static const String _userBoxName = 'users';
  static const String _currentUserKey = 'currentUser';

  final StreamController<UserEntity> _userController = StreamController<UserEntity>.broadcast();
  late final Box<UserModel> _userBox;
  UserEntity _currentUser = UserEntity.empty;

  // Constructor
  HiveAuthRepositoryImpl._();

  // Factory constructor for async initialization
  static Future<HiveAuthRepositoryImpl> create() async {
    // Register the adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    
    final instance = HiveAuthRepositoryImpl._();
    await instance._init();
    return instance;
  }

  // Initialize the repository
  Future<void> _init() async {
    _userBox = await Hive.openBox<UserModel>(_userBoxName);
    
    // Load current user from storage if exists
    final storedUser = _userBox.get(_currentUserKey);
    if (storedUser != null) {
      _currentUser = storedUser.toEntity();
    }
    
    // Emit initial user state
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
    // Check if user already exists
    if (_userBox.values.any((user) => user.email == email)) {
      throw Exception('User already exists with this email.');
    }
    
    // Create new user
    final newUser = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name ?? email.split('@').first,
    );
    
    // Store user in Hive with email as key
    await _userBox.put(email, UserModel.fromEntity(newUser));
    
    // Do not set as current user - signup should not auto-login
    _userController.add(_currentUser);
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Check if the user exists in our Hive box
    final existingUser = _userBox.get(email);
    
    if (existingUser == null) {
      // For testing purposes, allow a hardcoded user
      if (email == 'user@example.com' && password == 'password') {
        final defaultUser = UserEntity(
          id: 'default_user_id',
          email: email,
          name: 'Test User',
        );
        
        await _userBox.put(_currentUserKey, UserModel.fromEntity(defaultUser));
        _currentUser = defaultUser;
        _userController.add(_currentUser);
        return;
      }
      throw Exception('Invalid email or password.');
    }
    
    // In a real app, we would verify the password here
    // For this demo, we'll accept any password for a stored user
    
    // Set as current user
    await _userBox.put(_currentUserKey, existingUser);
    _currentUser = existingUser.toEntity();
    _userController.add(_currentUser);
  }

  @override
  Future<void> logOut() async {
    // Remove current user from storage
    await _userBox.delete(_currentUserKey);
    
    // Update current user and notify listeners
    _currentUser = UserEntity.empty;
    _userController.add(_currentUser);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    // In a real app, this would trigger a password reset flow
    // For demonstration, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }

  // Dispose method to clean up resources
  void dispose() {
    _userController.close();
    _userBox.close();
  }
}
