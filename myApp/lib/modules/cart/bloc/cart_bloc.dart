import 'dart:async';

import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/modules/cart/service/cart_service.dart';
import 'package:http_request/networking/response.dart';

class CartBloc {
  StreamController _cartStream;
  CartService _cartService;

  Stream<Response<ServerResponse>> get cartStream => _cartStream.stream;
  StreamSink<Response<ServerResponse>> get cartSink => _cartStream.sink;

  CartBloc() {
    _cartStream = new StreamController<Response<ServerResponse>>();
    _cartService = new CartService();
  }

  getCartList() async {
    try {
      // cartSink.add(Response.loading("Loading"));
      ServerResponse cartList = await _cartService.getCart();
      cartSink.add(Response.completed(cartList));
    } catch (e) {
      cartSink.addError(Response.error(e.toString()));
    }
  }

  Future<ServerResponse> addCart(int productId, int quantity) async {
    try {
      var params = Map<String, dynamic>();
      params["product_id"] = productId;
      params["quantity"] = quantity;
      // cartSink.add(Response.loading("Loading"));
      ServerResponse response = await _cartService.addCart(params);
      return response;
    } catch (e) {
      cartSink.addError(Response.error(e.toString()));
    }
  }

  updateCart(String cartId, int quantity) async {
    try {
      var params = Map<String, dynamic>();
      params["cart_id"] = cartId;
      params["quantity"] = quantity;
      // cartSink.add(Response.loading("Loading"));
      ServerResponse response = await _cartService.updateCart(params);
      getCartList();
    } catch (e) {
      cartSink.addError(Response.error(e.toString()));
    }
  }

  removeCart(String cartId) async {
    try {
      // cartSink.add(Response.loading("Loading"));
      ServerResponse cartList = await _cartService.removeCart(cartId);
      getCartList();
      // cartSink.add(Response.completed(cartList));
    } catch (e) {
      cartSink.addError(Response.error(e.toString()));
    }
  }

  Future<int> getCartTotal() async {
    Completer<int> c = new Completer();
    var totalQuantity = 0;

    try {
      ServerResponse response = await _cartService.getCartTotal();
      if (response.data["cart_total"] != null) {
        c.complete(response.data["cart_total"]);
      }
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }

  Future<int> getCartQuantity() async {
    Completer<int> c = new Completer();
    var totalQuantity = 0;
    try {
      ServerResponse response = await _cartService.getCart();
      if (response.data["products"] != null) {
        List<CartModel> items =
            List<CartModel>.from(response.data["products"].map((x) {
          return CartModel.fromJson(x);
        }));

        items.forEach((cartItem) {
          totalQuantity += cartItem.quantity;
        });
      }
      c.complete(totalQuantity);
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  dispose() {
    _cartStream.close();
  }
}
