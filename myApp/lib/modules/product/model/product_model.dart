const hostUrl = 'https://trongnv.me';

class ProductsModel {
  List<ProductModel> products;

  ProductsModel({this.products});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      products: json["data"]["products"] == null
          ? []
          : List<ProductModel>.from(
              json["data"]["products"].map((x) => ProductModel.fromJson(x))),
    );
  }
}

class ProductResponse {
  int code;
  ProductModel data;
  String message;

  ProductResponse({this.code, this.data, this.message});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        code: json["code"],
        data: !json.containsKey("data")
            ? ProductModel()
            : ProductModel.fromJson(json["data"]),
        message: json["message"],
      );
}

class ProductModel {
  int product_id;
  int category_id;
  String name;
  String image;
  int price;
  int final_price;
  int is_promotion;
  int percent_discount;
  // double rating_score;

  ProductModel({
    this.product_id,
    this.name,
    this.image,
    this.price,
    this.final_price,
    this.is_promotion,
    this.percent_discount,
    // this.rating_score,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // product_id: json['product_id'] as int,
      product_id: json['product_id'] == null ? 0 : json['product_id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as int,
      final_price: json['price'] as int,
      is_promotion: json['is_promotion'] as int,
      percent_discount: json['percent_discount'] as int,
      // rating_score: json['rating_score'] as double,
    );
  }

  toJson() => {
        'name': name,
        'image': image,
        'price': price,
      };
}

class SortProductList {
  String key;
  String title;

  SortProductList({this.key, this.title});
}
