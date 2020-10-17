import 'package:http_request/modules/home/model/home_model.dart';
import 'package:http_request/networking/api_provider.dart';

class HomeService {
  ApiProvider _provider = ApiProvider();

  Future<HomeModel> fetchHomeData() async {
    final response = await _provider.get("home");
    return HomeModel.fromJson(response);
  }
}
