import 'dart:async';

import 'package:http_request/modules/product_detail/model/product_detail_model.dart';
import 'package:http_request/modules/product_detail/service/product_detail_service.dart';
import 'package:http_request/networking/response.dart';

class ProductDetailBloc {
  ProductDetailService _productDetailService;
  StreamController _productDetailStream;

  Stream<Response<ProductDetailModel>> get productDetailDataStream =>
      _productDetailStream.stream;
  StreamSink<Response<ProductDetailModel>> get productDetailDataSink =>
      _productDetailStream.sink;

  ProductDetailBloc() {
    _productDetailService = new ProductDetailService();
    _productDetailStream = new StreamController<Response<ProductDetailModel>>();
  }

  fetchProductDetailById(int product_id) async {
    try {
      productDetailDataSink.add(Response.loading("Loading"));
      ProductDetailModel product =
          await _productDetailService.fetchProductDetailById(product_id);
      productDetailDataSink.add(Response.completed(product));
      // print(product);
    } catch (e) {
      productDetailDataSink.add(Response.error(e.toString()));
    }
  }

  Future<FavoriteResponse> setFavorite(int product_id) {
    Completer<FavoriteResponse> c = new Completer();
    var favoriteResponse = new FavoriteResponse();

    _productDetailService.addFavorite(product_id).then((response) {
      if (response != null) {
        favoriteResponse = response;
        c.complete(favoriteResponse);
      }
    });

    return c.future;
  }

  Future<FavoriteResponse> getFavorite(int product_id) {
    Completer<FavoriteResponse> c = new Completer();
    var favoriteResponse = new FavoriteResponse();

    _productDetailService.getFavorite(product_id).then((response) {
      if (response != null) {
        favoriteResponse = response;
        c.complete(favoriteResponse);
      }
    });

    return c.future;
  }

  void dispose() {
    _productDetailStream.close();
  }
}
