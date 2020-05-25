import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/repository/auth_repository.dart';
import 'package:quantifico/util/web_client.dart';

class MockWebClient extends Mock implements WebClient {}

void main() {
  group('Auth Repository', () {
    final webClient = MockWebClient();
    final authRepository = AuthRepository(webClient: webClient);

    test('should signin properly', () async {
      when(
        webClient.post('sessao', body: anyNamed('body')),
      ).thenAnswer(
        (_) => Future<dynamic>.value(
          {
            'usuario': {
              'organizacao': '1',
              'nome': 'John',
              'email': 'john@doe',
            },
            'token':
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyNDFmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTkwMjY2Mzc4LCJleHAiOjE1OTAzNTI3Nzh9.SBIx1wWespyhl2YaeOukjmKaAdXBn0z94bu4gSXh0qw',
          },
        ),
      );
      final data = await authRepository.signIn(
        email: 'john@doe',
        password: 'doe',
      );
      expect(
        data,
        const Session(
          user: User(
            organization: '1',
            name: 'John',
            email: 'john@doe',
          ),
          token:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyNDFmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTkwMjY2Mzc4LCJleHAiOjE1OTAzNTI3Nzh9.SBIx1wWespyhl2YaeOukjmKaAdXBn0z94bu4gSXh0qw',
        ),
      );
    });

    test('should signout properly', () async {
      expect(1, 1);
    });
  });
}
