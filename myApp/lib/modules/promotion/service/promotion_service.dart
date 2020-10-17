import 'package:http_request/networking/api_provider.dart';
import 'package:http_request/networking/response.dart';

class PromotionService {
  var _provider = ApiProvider();

  Future<ServerResponse> getPromotionList() async {
    final response = await _provider.get("/promotion/list");
    return ServerResponse.fromJson(response);
  }
}
