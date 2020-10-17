import 'package:http_request/modules/product/model/product_model.dart';

class CartModel {
  String cartId;
  int productId;
  String name;
  String image;
  int price;
  int customerId;
  int quantity;
  int status;
  int totalPrice;
  List<ProductModel> attatchProducts;

  CartModel({
    this.cartId,
    this.productId,
    this.name,
    this.image,
    this.price,
    this.customerId,
    this.quantity,
    this.status,
    this.totalPrice,
    this.attatchProducts,
  });

  factory CartModel.fromJson(json) => CartModel(
        cartId: json["cart_id"],
        productId: json["product_id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        customerId: json["customer_id"],
        quantity: json["quantity"],
        status: json["status"],
        totalPrice: json["total_price"] == null ? 0 : json["total_price"],
        attatchProducts: (json["attach_products"] == null)
            ? []
            : List<ProductModel>.from(
                json["attach_products"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'quantity': quantity,
        'price': price,
      };
}
