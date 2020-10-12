import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/login/bloc.dart';
import 'package:flutter_bloc_login_firebase/src/bloc/login/event.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      onPressed: (){
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Logging in...'),
                CircularProgressIndicator(),
              ],
            )
          )
        );
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed()
        );
      },
    );
  }
}