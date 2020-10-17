import 'package:http_request/networking/api_provider.dart';
import 'package:http_request/networking/response.dart';

class OrderService {
  ApiProvider _provider;

  OrderService() {
    _provider = new ApiProvider();
  }

  Future<ServerResponse> checkoutAction(Map<String, dynamic> params) async {
    // print(params);
    final response = await _provider.post("/order/checkout", params);
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> getOrderList() async {
    final response = await _provider.get("/order/list");
    return ServerResponse.fromJson(response);
  }

  Future<ServerResponse> getOrderDetail(int orderId) async {
    final response = await _provider.get("/order/detail/${orderId}");
    return ServerResponse.fromJson(response);
  }
}
