import 'package:http_request/modules/product/model/product_model.dart';

import '../../../networking/api_provider.dart';

class ProductService {
  ApiProvider _provider = ApiProvider();

  Future<List<ProductModel>> fetchProductsByCategoryId(int category_id) async {
    final response = await _provider.get("product/category/${category_id}");
    List<ProductModel> products;
    products = List<ProductModel>.from(
        response["data"]["products"].map((x) => ProductModel.fromJson(x)));
    return products;
  }

  Future<List<ProductModel>> fetchProductsByCategoryIdParams(
      int category_id, Map<String, dynamic> params) async {
    String endpoint = "product/category/${category_id}";
    if (params != null) endpoint += "?";

    if (params.containsKey("order")) {
      endpoint += "&order=" + params["order"];
    }

    if (params.containsKey("price")) {
      endpoint += "&price=" + params["price"];
    }

    // print(endpoint);

    final response = await _provider.get(endpoint);
    // print(response);
    List<ProductModel> products;
    products = List<ProductModel>.from(
        response["data"]["products"].map((x) => ProductModel.fromJson(x)));
    return products;
  }

  Future<List<ProductModel>> fetchSortProduct(
      int category_id, String sortKey) async {
    final response =
        await _provider.get("product/category/${category_id}?order=${sortKey}");
    return List<ProductModel>.from(
        response["data"]["products"].map((x) => ProductModel.fromJson(x)));
  }
}
