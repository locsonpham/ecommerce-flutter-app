import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/search/model/search_model.dart';
import 'package:http_request/networking/api_provider.dart';

class SearchService {
  ApiProvider _provider = ApiProvider();

  Future<SearchResponse> searchProductByParams(String q, int p) async {
    String endpoint = "/product/search?q=${q}&p=${p}";

    var response = await _provider.get(endpoint);
    // print(response);
    return SearchResponse.fromJson(response);
  }
}
