import 'dart:async';
import 'dart:convert';

import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product_detail/model/product_detail_model.dart';
import 'package:http_request/modules/product_detail/service/product_detail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentViewBloc {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  setRecentProduct(ProductDetailModel product) async {
    final SharedPreferences prefs = await _prefs;
    List<String> _products;
    _products = await getRecentProduct();

    // product model to json
    var productJson = product.toJson();
    String jsonP = jsonEncode(productJson);

    if (_products.length == 0) {
      _products.insert(0, jsonP);
    }

    if (_products.length > 0) {
      for (var index = 0; index < _products.length; index++) {
        if (_products[index] == jsonP) _products.removeAt(index);
      }
      _products.insert(0, jsonP);
      if (_products.length > 6) _products.removeLast();
    }

    await prefs.setStringList('recent_view', _products);
  }

  Future<List<String>> getRecentProduct() async {
    List<String> productsJson;
    final SharedPreferences prefs = await _prefs;
    productsJson = prefs.getStringList('recent_view') ?? List<String>();
    return productsJson;
  }

  Future<List<ProductDetailModel>> getRecentProductList() async {
    List<ProductDetailModel> _products = List<ProductDetailModel>();
    ProductDetailService _productService = ProductDetailService();

    List<String> _recentProducts = await getRecentProduct();
    for (var index = _recentProducts.length - 1; index >= 0; index--) {}
    return _products;
  }
}
