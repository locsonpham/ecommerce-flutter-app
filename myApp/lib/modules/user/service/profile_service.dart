import 'package:http_request/networking/api_provider.dart';
import 'package:http_request/networking/response.dart';

class ProfileService {
  ApiProvider _provider;

  ProfileService() {
    _provider = ApiProvider();
  }

  Future<ServerResponse> getUserProfile() async {
    String uri = "user/profile";
    var response = await _provider.get(uri);
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> updateUserProfile(Map<String, dynamic> params) async {
    String uri = "user/profile/update";
    var response = await _provider.put(uri, params);
    return ServerResponse.fromJson(response);
  }
}
