import 'dart:async';

import 'package:http_request/modules/home/model/home_model.dart';
import 'package:http_request/modules/home/service/home_service.dart';
import 'package:http_request/networking/response.dart';

class HomeBloc {
  HomeService _homeService;

  StreamController _homeStreamController;

  Stream<Response<HomeModel>> get homeDataStream =>
      _homeStreamController.stream;

  StreamSink<Response<HomeModel>> get homeDataSink =>
      _homeStreamController.sink;

  HomeBloc() {
    _homeStreamController = StreamController<Response<HomeModel>>();
    _homeService = new HomeService();
    _fetchHomeData();
  }

  _fetchHomeData() async {
    try {
      homeDataSink.add(Response.loading("Loading"));
      HomeModel homeData = await _homeService.fetchHomeData();
      homeDataSink.add(Response.completed(homeData));
    } catch (e) {
      homeDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  void dispose() {
    _homeStreamController.close();
  }
}
