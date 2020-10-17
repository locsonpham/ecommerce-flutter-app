import 'dart:async';

import 'package:http_request/modules/search/model/search_model.dart';
import 'package:http_request/modules/search/service/search_service.dart';
import 'package:http_request/networking/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBloc {
  StreamController _searchStreamController;
  SearchService _searchService;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> _searchKeyList;

  Stream<Response<SearchResponse>> get searchDataStream =>
      _searchStreamController.stream;
  StreamSink<Response<SearchResponse>> get searchDataSink =>
      _searchStreamController.sink;

  SearchBloc() {
    _searchStreamController = new StreamController<Response<SearchResponse>>();
    _searchService = new SearchService();
    _searchKeyList = new List<String>(5);
  }

  searchProduct(String q, int p) async {
    try {
      searchDataSink.add(Response.loading("Searching"));
      SearchResponse data = await _searchService.searchProductByParams(q, p);
      searchDataSink.add(Response.completed(data));
    } catch (e) {
      searchDataSink.add(Response.error(e.toString()));
    }
  }

  Future<bool> addSearchKeyList(String key) async {
    final SharedPreferences prefs = await _prefs;
    listFIFOAction(_searchKeyList);
    _searchKeyList[0] = key;
    prefs.setStringList('recent_search', _searchKeyList);
  }

  void listFIFOAction(List<String> list) {
    var length = list.length;
    for (var i = length - 1; i > 0; i--) {
      list[i] = list[i - 1];
    }
  }

  Future<List<String>> getSearchKeyList() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getStringList('recent_search') != null)
      _searchKeyList = prefs.getStringList('recent_search');
    return _searchKeyList;
  }
}
