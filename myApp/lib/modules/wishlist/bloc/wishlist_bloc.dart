import 'dart:async';

import 'package:http_request/modules/wishlist/service/wishlist_service.dart';
import 'package:http_request/networking/response.dart';

class WishListBloc {
  WishlistService _service;
  StreamController _stream;

  Stream<Response<ServerResponse>> get wishlistStream => _stream.stream;
  StreamSink<Response<ServerResponse>> get wishlistSink => _stream.sink;

  WishListBloc() {
    _stream = StreamController<Response<ServerResponse>>();
    _service = WishlistService();
  }

  getWishlist() async {
    try {
      wishlistSink.add(Response.loading("Loading"));
      ServerResponse response = await _service.getWishList();
      wishlistSink.add(Response.completed(response));
    } catch (e) {
      wishlistSink.add(Response.error(e.toString()));
    }
  }
}
