import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/event.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/state.dart';
import 'package:flutter_bloc_login_firebase/src/repository/user_repository.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
    : assert(userRepository != null), _userRepository = userRepository;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield await Future.delayed(Duration(seconds: 5), (){
          return AuthenticationAuthenticated(user);
        });
      }
      else {
        yield await Future.delayed(Duration(seconds: 5), (){
          return AuthenticationUnauthenticated();
        });
      }
    } catch (_) {
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticationAuthenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticationUnauthenticated();
    _userRepository.signOut();
  }
}