import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/event.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/state.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/simple_bloc_delegate.dart';
import 'package:flutter_bloc_login_firebase/src/repository/user_repository.dart';
import 'package:flutter_bloc_login_firebase/src/ui/home_screen.dart';
import 'package:flutter_bloc_login_firebase/src/ui/login/login_screen.dart';
import 'package:flutter_bloc_login_firebase/src/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository}) :
    assert (userRepository != null), _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }
          if (state is AuthenticationAuthenticated) {
            return HomeScreen(name: state.displayName,);
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginScreen(userRepository: _userRepository,);
          }
          return Container();
        },
      ),
    );
  }
}