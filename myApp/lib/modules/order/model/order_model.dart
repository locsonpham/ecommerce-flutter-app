import 'package:http_request/modules/cart/model/cart_model.dart';

class OrderInfo {
  CustomerInfo customer;
  List<CartModel> products;

  OrderInfo({this.customer, this.products});
}

class CustomerInfo {
  String name;
  String address;
  String phone;
  String comment;

  CustomerInfo({
    this.name,
    this.address,
    this.phone,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'phone': phone,
        'comment': comment,
      };
}

class OrderListModel {
  List<OrderDetailModel> orderList;

  OrderListModel({this.orderList});

  factory OrderListModel.fromJson(json) => OrderListModel(
      orderList: List<OrderDetailModel>.from(
          json.map((x) => OrderDetailModel.fromJson(x))));
}

class OrderDetailModel {
  int orderId;
  int customerId;
  int totalQuantity;
  int totalAmount;
  int status;
  String createdAt;
  String comments;
  String name;
  String phone;
  String address;
  String invoiceAddress;
  int feeShip;
  List<CartModel> products;

  OrderDetailModel({
    this.orderId,
    this.customerId,
    this.totalQuantity,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.comments,
    this.name,
    this.phone,
    this.address,
    this.invoiceAddress,
    this.feeShip,
    this.products,
  });

  factory OrderDetailModel.fromJson(json) => OrderDetailModel(
        orderId: json["order_id"],
        customerId: json["customer_id"],
        totalQuantity: json["total_quantity"],
        totalAmount: json["total_amount"],
        status: json["status"],
        createdAt: json["created_at"],
        comments: json["comments"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        invoiceAddress: json["invoice_address"],
        feeShip: json["fee_ship"],
        products: List<CartModel>.from(json["products"].map((x) {
          // print(x);
          return CartModel.fromJson(x);
        })),
      );
}
