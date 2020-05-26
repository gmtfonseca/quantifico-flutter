import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quantifico/data/model/network_exception.dart';

const String _baseUrl = '10.0.2.2:3000';
// const String _baseUrl = '5fd8ee9c.ngrok.io';

class WebClient {
  final String baseUrl;
  Map<String, String> _headers;

  WebClient([this.baseUrl = _baseUrl]) {
    _headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
  }

  Future<dynamic> fetch(
    String endpoint, {
    Map<String, String> params,
    Map<String, String> headers,
  }) async {
    try {
      final uri = Uri.http(
        baseUrl,
        endpoint,
        params,
      );
      final response = await http.get(
        uri,
        headers: {}..addAll(_headers)..addAll(headers ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NoConnectionException();
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String> body,
    Map<String, String> params,
    Map<String, String> headers,
  }) async {
    try {
      final uri = Uri.http(
        baseUrl,
        endpoint,
        params,
      );
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {}..addAll(_headers)..addAll(headers ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NoConnectionException();
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;
    if (response.body != null) {
      body = jsonDecode(response.body);
    }
    switch (response.statusCode) {
      case HttpStatus.ok:
        return body;
      case HttpStatus.badRequest:
        throw BadRequestException(response.statusCode, body as Map<dynamic, dynamic>);
      case HttpStatus.unauthorized:
        throw UnauthorizedRequestException(response.statusCode, body as Map<dynamic, dynamic>);
      default:
        throw HttpException(response.statusCode);
    }
  }
}
