import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String _token =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyNDFmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTg5MDMzMDM4LCJleHAiOjE1ODkxMTk0Mzh9.sxwHfrp5bnQjb2MILg8s2fnj2Ok4WGqfXxSQnv6htFU";

//const String _baseUrl = '10.0.2.2:3000';
//lt -h "http://serverless.social" -p 3000
const String _baseUrl = 'little-frog-50.serverless.social';

class UnauthorizedException implements Exception {}

class BadRequestException implements Exception {}

class WebClient {
  final String baseUrl;
  final Map<String, String> headers;

  WebClient([this.baseUrl = _baseUrl]) : headers = {HttpHeaders.authorizationHeader: _token};

  Future<dynamic> fetch(String endpoint, {Map<String, String> params}) async {
    final uri = Uri.http(baseUrl, endpoint, params);
    final response = await http.get(
      uri,
      headers: headers,
    );
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
