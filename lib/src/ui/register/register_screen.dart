import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/register/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/repository/user_repository.dart';
import 'package:flutter_bloc_login_firebase/src/ui/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
    :assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup'),),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}