import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String _token =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyNDFmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTg4NDczMzMzLCJleHAiOjE1ODg1NTk3MzN9.j8Wf1i6t8wy5DeA1DZ28nopB4YBqwYjGDikawDMqiCk";

const String _baseUrl = 'http://10.0.2.2:3000';

class UnauthorizedException implements Exception {}

class BadRequestException implements Exception {}

class WebClient {
  final String baseUrl;
  final Map<String, String> headers;

  WebClient([this.baseUrl = _baseUrl]) : headers = {HttpHeaders.authorizationHeader: _token};

  String url(endpoint) => '$baseUrl/$endpoint';

  Future<dynamic> fetch(String endpoint) async {
    final response = await http.get(url(endpoint), headers: headers);
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException();
      case 401:
        throw UnauthorizedException();
      default:
        throw Exception('Exception: status code ${response.statusCode}');
    }
  }
}
