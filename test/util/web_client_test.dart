import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/util/web_client.dart';

void main() {
  group('Chart Web Provider', () {
    WebClient webClient = WebClient('https://reqbin.com/echo');

    test('should fetch correctly', () async {
      final response = await webClient.fetch('/get/json');
      expect(
        response.body.trim(),
        '{"success":"true"}',
      );
    });
  });
}
