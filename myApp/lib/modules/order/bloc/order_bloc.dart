import 'dart:async';

import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/modules/order/model/order_model.dart';
import 'package:http_request/modules/order/service/order_service.dart';
import 'package:http_request/networking/response.dart';

class OrderBloc {
  OrderService _service;
  StreamController _orderStream;

  Stream<Response<ServerResponse>> get orderStream => _orderStream.stream;
  StreamSink<Response<ServerResponse>> get orderSink => _orderStream.sink;

  OrderBloc() {
    _service = OrderService();
    _orderStream = StreamController<Response<ServerResponse>>();
  }

  orderAction(dynamic params) async {
    var _params = Map<String, dynamic>();
    var order = OrderInfo();
    order = params;

    _params["customer"] = order.customer.toJson();
    _params["products"] = List();

    order.products.forEach((x) {
      _params["products"].add(x.toJson());
    });

    try {
      orderSink.add(Response.loading("Loading"));
      ServerResponse response = await _service.checkoutAction(_params);
      orderSink.add(Response.completed(response));
    } catch (e) {
      orderSink.addError(e.toString());
    }
  }

  Future<ServerResponse> checkoutAction(OrderInfo orderInfo) async {
    Completer<ServerResponse> _completer = new Completer();
    var _params = Map<String, dynamic>();

    _params["customer"] = orderInfo.customer.toJson();
    _params["products"] = List();

    orderInfo.products.forEach((x) {
      _params["products"].add(x.toJson());
    });

    try {
      ServerResponse response = await _service.checkoutAction(_params);
      _completer.complete(response);
    } catch (e) {
      _completer.completeError(e);
    }

    return _completer.future;
  }

  getOrderList() async {
    try {
      orderSink.add(Response.loading("Loading"));
      ServerResponse response = await _service.getOrderList();
      orderSink.add(Response.completed(response));
    } catch (e) {
      orderSink.addError(e.toString());
    }
  }

  getOrderDetail(int orderId) async {
    try {
      orderSink.add(Response.loading("Loading"));
      ServerResponse response = await _service.getOrderDetail(orderId);
      orderSink.add(Response.completed(response));
    } catch (e) {
      orderSink.addError(e.toString());
    }
  }

  dispose() {
    _orderStream.close();
  }
}
