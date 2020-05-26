import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/login_screen/barrel.dart';
import 'package:quantifico/data/repository/user_repository.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final UserRepository userRepository;

  LoginScreenBloc({
    @required this.userRepository,
  });

  @override
  LoginScreenState get initialState => const NotSignedIn();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    if (event is SignIn) {
      yield* _mapSignInToState(event);
    }
  }

  Stream<LoginScreenState> _mapSignInToState(SignIn event) async* {
    try {
      yield SigningIn();
      final session = await userRepository.signIn(
        email: event.email,
        password: event.password,
      );
      yield SignedIn(session);
    } on InvalidCredentialsException catch (e) {
      yield NotSignedIn(msg: e.msg);
    } catch (e) {
      yield const NotSignedIn();
    }
  }
}
