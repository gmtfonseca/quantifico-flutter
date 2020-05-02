import 'dart:io';
import 'package:http/http.dart' as http;

const String _token =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyNDFmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTg4Mzc4OTk4LCJleHAiOjE1ODg0NjUzOTh9.1kokwIk2TPCt5b3RVyCCN01IxvFmaGPRFIZCgdPyU3Y";

const String _url = 'http://10.0.2.2:3000';

class WebClient {
  final String url;
  final Map<String, String> headers;

  WebClient([this.url = _url]) : headers = {HttpHeaders.authorizationHeader: _token};

  Future<http.Response> fetch(String endpoint) async {
    return await http.get(url + endpoint, headers: headers);
  }
}
