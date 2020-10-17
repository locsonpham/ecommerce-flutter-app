class SearchResponse {
  int code;
  dynamic data;
  String message;

  SearchResponse({this.code, this.data, this.message});

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        code: json["code"],
        data: (!json.containsKey("data")) ? SearchResponse() : json["data"],
        message: json["message"],
      );
}
