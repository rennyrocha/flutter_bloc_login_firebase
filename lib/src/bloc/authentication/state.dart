import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState{
  @override
  String toString() => 'Authentication not initialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  final String displayName;

  const AuthenticationAuthenticated(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Hi :$displayName';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'Not authenticated';
}