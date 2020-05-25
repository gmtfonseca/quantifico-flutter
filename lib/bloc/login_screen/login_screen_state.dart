import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/session.dart';

abstract class LoginScreenState extends Equatable {
  const LoginScreenState();

  @override
  List<Object> get props => [];
}

class SigningIn extends LoginScreenState {}

class NotSignedIn extends LoginScreenState {
  final String msg;

  const NotSignedIn({this.msg});

  @override
  List<Object> get props => [msg];
}

class SignedIn extends LoginScreenState {
  final Session session;

  const SignedIn(this.session);

  @override
  List<Object> get props => [session];
}
