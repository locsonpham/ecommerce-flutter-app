import 'package:shared_preferences/shared_preferences.dart';

Future<String> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('access_token') ?? null);
  return token;
}

Future<dynamic> getPrefsByKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (key) {
    case 'access_token':
      {
        break;
      }
    default:
      return null;
  }
}
