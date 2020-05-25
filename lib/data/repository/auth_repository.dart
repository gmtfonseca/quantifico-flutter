import 'package:meta/meta.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/util/web_client.dart';

class InvalidCredentialsException implements Exception {
  final String msg;
  const InvalidCredentialsException(this.msg);
}

class AuthRepository {
  final WebClient webClient;
  final TokenLocalProvider tokenLocalProvider;

  AuthRepository({
    @required this.webClient,
    @required this.tokenLocalProvider,
  });

  Future<Session> signIn({
    String email,
    String password,
  }) async {
    try {
      final jsonBody = await webClient.post(
        'sessao',
        body: {'email': email, 'senha': password},
      ) as Map<dynamic, dynamic>;

      final session = Session.fromJson(jsonBody);
      tokenLocalProvider.setToken(session.token);
      return session;
    } catch (e) {
      if (e is UnauthorizedRequestException || e is BadRequestException) {
        final msg = e.body['errors'][0]['messages'][0] as String;
        throw InvalidCredentialsException(msg);
      } else {
        rethrow;
      }
    }
  }

  Future<bool> isAuthenticated() async {
    return tokenLocalProvider.hasValidToken();
  }

  Future<String> getToken() async {
    return tokenLocalProvider.getToken();
  }

  Future<void> signOut() async {}
}
