enum Status { LOADING, COMPLETED, ERROR }

class Response<T> {
  Status status;
  T data;
  String message;

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

class ServerResponse {
  int code;
  dynamic data;
  String message;

  ServerResponse({
    this.code,
    this.data,
    this.message,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        code: json["code"],
        data: (!json.containsKey("data")) ? ServerResponse() : json["data"],
        message: json["message"],
      );
}
