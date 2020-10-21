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
    List<String> _searchKeyList;
    _searchKeyList = await getSearchKeyList();

    if (_searchKeyList.length == 0) {
      _searchKeyList.insert(0, key);
    }

    if (_searchKeyList.length > 0) {
      for (var index = 0; index < _searchKeyList.length; index++) {
        if (_searchKeyList[index] == key) _searchKeyList.removeAt(index);
      }
      _searchKeyList.insert(0, key);
      if (_searchKeyList.length > 6) _searchKeyList.removeLast();
    }
    await prefs.setStringList('recent_search', _searchKeyList);

    return true;
  }

  Future<List<String>> getSearchKeyList() async {
    final SharedPreferences prefs = await _prefs;
    _searchKeyList = prefs.getStringList('recent_search') ?? List<String>();
    return _searchKeyList;
  }
}
