import 'dart:async';

import 'package:http_request/modules/product_detail/model/product_detail_model.dart';
import 'package:http_request/networking/api_provider.dart';

class ProductDetailService {
  ApiProvider _provider = ApiProvider();

  Future<ProductDetailModel> fetchProductDetailById(int product_id) async {
    final response = await _provider.get("product/detail/${product_id}");
    if (response["data"] != null) {
      return ProductDetailModel.fromJson(response["data"]);
    }
    return ProductDetailModel();
  }

  Future<FavoriteResponse> addFavorite(int product_id) async {
    var params = Map<String, dynamic>();
    params['product_id'] = product_id;

    final response = await _provider.post("product/wishlist/add", params);
    return FavoriteResponse.fromJson(response);
  }

  Future<FavoriteResponse> getFavorite(int product_id) async {
    final response =
        await _provider.get("product/wishlist/exist/${product_id}");
    return FavoriteResponse.fromJson(response);
  }
}
