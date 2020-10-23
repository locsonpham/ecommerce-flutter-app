import 'package:http_request/modules/user/service/profile_service.dart';
import 'package:http_request/networking/response.dart';

class ProfileBloc {
  ProfileService _service;

  ProfileBloc() {
    _service = ProfileService();
  }

  Future<ServerResponse> updateUserProfile(Map<String, dynamic> params) async {
    try {
      ServerResponse response = await _service.updateUserProfile(params);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }
}
