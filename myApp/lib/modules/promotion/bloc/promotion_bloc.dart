import 'dart:async';

import 'package:http_request/modules/promotion/service/promotion_service.dart';
import 'package:http_request/networking/response.dart';

class PromotionBloc {
  PromotionService _service;
  StreamController _stream;

  Stream<Response<ServerResponse>> get promotionStream => _stream.stream;
  StreamSink<Response<ServerResponse>> get promotionSink => _stream.sink;

  PromotionBloc() {
    _stream = StreamController<Response<ServerResponse>>();
    _service = PromotionService();
  }

  getPromotionList() async {
    try {
      promotionSink.add(Response.loading("Loading"));
      ServerResponse response = await _service.getPromotionList();
      promotionSink.add(Response.completed(response));
    } catch (e) {
      promotionSink.add(Response.error(e.toString()));
    }
  }
}
