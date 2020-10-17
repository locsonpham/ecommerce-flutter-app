import 'dart:async';

import 'package:flutter/material.dart';

import '../../networking/response.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/service/cart_service.dart';
import '../cart/service/cart_service.dart';

class CartTotalBloc {
  StreamController stream;
  CartService _cartService;
  Stream<int> get cartTotalStream => stream.stream;
  StreamSink<int> get cartTotalSink => stream.sink;

  CartTotalBloc() {
    stream = StreamController<int>();
    _cartService = CartService();
  }

  Future<int> getCartTotal() async {
    Completer<int> c = new Completer();
    var totalQuantity = 0;

    try {
      ServerResponse response = await _cartService.getCartTotal();
      if (response.data["cart_total"] != null) {
        cartTotalSink.add(response.data["cart_total"]);
        c.complete(response.data["cart_total"]);
      }
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }

  dispose() {
    stream.close();
  }
}

Widget cartWidget(BuildContext context, CartTotalBloc bloc) {
  return StreamBuilder<int>(
      stream: bloc.cartTotalStream,
      builder: (context, snapshot) {
        return Container(
          // color: Colors.blue,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/cart");
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.shopping_cart),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        );
      });
}
