part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the authentication state changes (e.g., user logs in or out).
/// It carries the new [user] data.
class AuthUserChanged extends AuthEvent {
  final UserEntity user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Event triggered when the user requests to log out.
class AuthLogoutRequested extends AuthEvent {}
