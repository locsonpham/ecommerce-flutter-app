import 'dart:async';

import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product/service/product_service.dart';
import 'package:http_request/networking/response.dart';

class ProductBloc {
  ProductService _productService;

  StreamController _productStreamController;

  Stream<Response<List<ProductModel>>> get productDataStream =>
      _productStreamController.stream;

  StreamSink<Response<List<ProductModel>>> get productDataSink =>
      _productStreamController.sink;

  ProductBloc() {
    _productStreamController = StreamController<Response<List<ProductModel>>>();
    _productService = new ProductService();
  }

  fetchProductsByCategoryId(int category_id) async {
    try {
      productDataSink.add(Response.loading("Loading"));
      List<ProductModel> productData =
          await _productService.fetchProductsByCategoryId(category_id);
      productDataSink.add(Response.completed(productData));
    } catch (e) {
      productDataSink.add(Response.error(e.toString()));
    }
  }

  fetchProductsByCategoryIdParams(
      int category_id, Map<String, dynamic> params) async {
    try {
      productDataSink.add(Response.loading("Loading"));
      List<ProductModel> productData = await _productService
          .fetchProductsByCategoryIdParams(category_id, params);
      productDataSink.add(Response.completed(productData));
    } catch (e) {
      productDataSink.add(Response.error(e.toString()));
    }
  }

  fetchSortProduct(int category_id, String sortKey) async {
    try {
      productDataSink.add(Response.loading("Loading"));
      List<ProductModel> products =
          await _productService.fetchSortProduct(category_id, sortKey);
      productDataSink.add(Response.completed(products));
    } catch (e) {
      productDataSink.add(Response.error(e.toString()));
    }
  }

  void dispose() {
    _productStreamController.close();
  }
}
