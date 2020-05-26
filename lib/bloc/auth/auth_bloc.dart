import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/repository/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({this.userRepository});

  @override
  AuthState get initialState => Authenticating();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is Authenticate) {
      yield* _mapAuthenticateToState(event);
    } else if (event is CheckAuthentication) {
      yield* _mapCheckAuthentication();
    }
  }

  Stream<AuthState> _mapAuthenticateToState(Authenticate event) async* {
    yield Authenticated(event.session);
  }

  Stream<AuthState> _mapCheckAuthentication() async* {
    final isAuthenticated = await userRepository.isAuthenticated();

    if (isAuthenticated) {
      // TODO - Também buscar email e usuario
      final token = await userRepository.getToken();
      yield Authenticated(
        Session(
          user: const User(organization: '', name: '', email: ''),
          token: token,
        ),
      );
    } else {
      yield NotAuthenticated();
    }
  }
}
