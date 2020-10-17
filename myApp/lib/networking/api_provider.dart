import 'package:http_request/networking/custom_expection.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
// import 'package:dio/dio.dart' as dio;

import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final String _baseUrl = "https://trongnv.me/api/";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<dynamic> get(String uri) async {
    var responseJson;
    final SharedPreferences prefs = await _prefs;
    var _access_token = (prefs.getString('access_token') ?? null);

    var _headers = Map<String, String>();
    if (_access_token != null) {
      _headers['Authorization'] = 'Bearer ${_access_token}';
    }

    try {
      final response = await http.get(
        _baseUrl + uri,
        headers: _headers,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String uri, Map<String, dynamic> params) async {
    var responseJson;
    final SharedPreferences prefs = await _prefs;
    var _access_token = (prefs.getString('access_token') ?? null);

    var _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (_access_token != null) {
      _headers['Authorization'] = 'Bearer ${_access_token}';
    }

    try {
      final response = await http.post(
        _baseUrl + uri,
        headers: _headers,
        body: jsonEncode(params),
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String uri, Map<String, dynamic> params) async {
    var responseJson;
    final SharedPreferences prefs = await _prefs;
    var _access_token = (prefs.getString('access_token') ?? null);

    var _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (_access_token != null) {
      _headers['Authorization'] = 'Bearer ${_access_token}';
    }

    try {
      final response = await http.put(
        _baseUrl + uri,
        headers: _headers,
        body: jsonEncode(params),
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String uri, Map<String, dynamic> params) async {
    var responseJson;
    final SharedPreferences prefs = await _prefs;
    var _access_token = (prefs.getString('access_token') ?? null);

    var _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json';

    if (_access_token != null) {
      _headers['Authorization'] = 'Bearer ${_access_token}';
    }

    // dio.Response response = await dio;

    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        // throw BadRequestException(response.body.toString());
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 401:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
