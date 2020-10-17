import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/networking/api_provider.dart';
import 'package:http_request/networking/response.dart';

class CartService {
  ApiProvider _provider = ApiProvider();

  Future<ServerResponse> getCart() async {
    final response = await _provider.get("cart/list");
    // print(response);
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> getCartTotal() async {
    final response = await _provider.get("/cart/total");
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> addCart(Map<String, dynamic> params) async {
    final response = await _provider.post("cart/add", params);
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> updateCart(Map<String, dynamic> params) async {
    final response = await _provider.put("cart/update", params);
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> removeCart(String cartId) async {
    final response = await _provider.delete("cart/remove", {"cart_id": cartId});
    return ServerResponse.fromJson(response);
  }
}
