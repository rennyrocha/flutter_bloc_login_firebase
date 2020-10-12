import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/event.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/login/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/authentication/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/login/event.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/login/state.dart';
import 'package:flutter_bloc_login_firebase/src/repository/user_repository.dart';
import 'package:flutter_bloc_login_firebase/src/ui/widgets/create_account_button.dart';
import 'package:flutter_bloc_login_firebase/src/ui/widgets/google_login_button.dart';
import 'package:flutter_bloc_login_firebase/src/ui/widgets/login_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Login Failed'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Logging in... '),
                CircularProgressIndicator(),
              ],
            ),
          ));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 200,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_){
                    return !state.isEmailValid? 'Invalid Email': null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password'
                  ),
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_){
                    return !state.isPasswordValid? 'Invalid Password': null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginButton(
                        onPressed: isLoginButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                      ),
                      GoogleLoginButton(),
                      CreateAccountButton(userRepository: _userRepository,),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text
      )
    );
  }
}
