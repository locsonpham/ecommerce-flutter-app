import 'package:http_request/networking/api_provider.dart';
import 'package:http_request/networking/response.dart';

class WishlistService {
  var _provider = ApiProvider();

  Future<ServerResponse> getWishList() async {
    final response = await _provider.get("/product/wishlist");
    return ServerResponse.fromJson(response);
  }
}
