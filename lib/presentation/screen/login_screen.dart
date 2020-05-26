import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/login_screen/barrel.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  final LoginScreenBloc bloc;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginScreen({this.bloc})
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenBloc, LoginScreenState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is SignedIn) {
          final authBloc = BlocProvider.of<AuthBloc>(context);
          authBloc.add(Authenticate(session: state.session));
        }
      },
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 20.0),
                      _buildEmailField(state),
                      const SizedBox(height: 20.0),
                      _buildPasswordField(state),
                      const SizedBox(height: 20.0),
                      _buildInvalidCredentialsText(state),
                      const SizedBox(height: 45.0),
                      _buildSigninButton(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return const SizedBox(
      height: 150,
      width: 150,
      child: Image(
        image: AssetImage('assets/logo.png'),
      ),
    );
  }

  Widget _buildEmailField(LoginScreenState state) {
    if (state is LoginScreenLoaded) {
      emailController.text = state.email;
    }
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      enabled: state is! SigningIn,
    );
  }

  Widget _buildPasswordField(LoginScreenState state) {
    return TextField(
      controller: passwordController,
      decoration: const InputDecoration(labelText: 'Senha'),
      enabled: state is! SigningIn,
      obscureText: true,
    );
  }

  Widget _buildInvalidCredentialsText(LoginScreenState state) {
    if (state is NotSignedIn && state.error != null) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          state.error,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildSigninButton(BuildContext context, LoginScreenState state) {
    if (state is SigningIn) {
      return const LoadingIndicator();
    } else {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: FlatButton(
                onPressed: () {
                  bloc.add(SignIn(
                    email: emailController.text,
                    password: passwordController.text,
                  ));
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: const Text('ENTRAR'),
              ),
            ),
          ),
        ],
      );
    }
  }
}
