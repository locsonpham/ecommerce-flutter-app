import 'package:flutter/gestures.dart';
import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/networking/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  ApiProvider _provider = ApiProvider();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<dynamic> signInAction({Map<String, dynamic> params}) async {
    final response = await _provider.post("user/sign-in", params);

    if (response['data'] != null) {
      if (response["data"]["token"] != null) {
        saveAccessToken(response["data"]["token"]);
      }
    }

    return SignInResponse.fromJson(response);
  }

  Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("access_token", token).then((bool success) {
      print(success);
    });
  }
}
