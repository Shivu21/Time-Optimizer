import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_optimizer/domain/auth/entities/user_entity.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          // Initialize with current user status if available, otherwise unauthenticated.
          // This relies on the repository's currentUser getter being synchronous and fast.
          authRepository.currentUser != null && authRepository.currentUser!.isNotEmpty
              ? AuthState.authenticated(authRepository.currentUser!)
              : const AuthState.unauthenticated(),
        ) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user.isNotEmpty) {
      emit(AuthState.authenticated(event.user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // In a real app, you might want to emit a loading state here.
    // emit(state.copyWith(status: AuthStatus.loading)); // If AuthState had a copyWith and loading status
    try {
      await _authRepository.logOut();
      // The user stream from the repository should then emit UserEntity.empty,
      // which will be picked up by the _userSubscription and trigger an AuthUserChanged event,
      // leading to the AuthUnauthenticated state.
    } catch (e) {
      // Handle logout error, perhaps emit an error state
      // emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
      print('Error logging out: $e');
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
