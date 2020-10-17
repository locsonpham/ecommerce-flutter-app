import 'package:http_request/modules/product/model/product_model.dart';

const hostUrl = 'https://trongnv.me';

class ProductDetailModel {
  int product_id;
  int category_id;
  int category_parent_id;
  String sku;
  String name;
  int price;
  int final_price;
  int is_promotion;
  int percent_discount;
  String image;
  // List<String> images_url;
  int stock;
  int display;
  dynamic rating_score;
  int rating_count;
  int quantity;
  List<ProductModel> related_products;
  List<ProductInfoTab> product_info_tabs;
  dynamic ratings;

  // double rating_score;

  ProductDetailModel(
      {this.product_id,
      this.category_id,
      this.category_parent_id,
      this.sku,
      this.name,
      this.price,
      this.final_price,
      this.is_promotion,
      this.percent_discount,
      this.image,
      // this.images_url,
      this.stock,
      this.display,
      this.rating_score,
      this.rating_count,
      this.quantity,
      this.related_products,
      this.product_info_tabs,
      this.ratings});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      product_id: json['product_id'] == null ? 0 : json['product_id'] as int,
      category_id: json['category_id'] == null ? 0 : json['catgegory_id'],
      category_parent_id:
          json['category_parent_id'] == null ? 0 : json['category_parent_id'],
      sku: json['sku'] == null ? "" : json['sku'],
      name: json['name'] as String,
      price: json['price'] as int,
      final_price: json['price'] as int,
      is_promotion: json['is_promotion'] as int,
      percent_discount: json['percent_discount'] as int,
      image: hostUrl + json['image'],
      // images_url: json['images_url'],
      stock: json['stock'],
      display: json['display'],
      rating_score: json['rating_score'],
      rating_count: json['rating_count'],
      quantity: json['quantity'],
      related_products: json['related_products'] == null
          ? []
          : List<ProductModel>.from(json['related_products'].map((x) {
              return ProductModel.fromJson(x);
            })),
      product_info_tabs: json['product_info_tabs'] == null
          ? null
          : List<ProductInfoTab>.from(json['product_info_tabs'].map((x) {
              return ProductInfoTab.fromJson(x);
            })),
      ratings: json['ratings'],
    );
  }

  toJson() => {
        'name': name,
        'image': image,
        'price': price,
      };
}

class ProductInfoTab {
  String type;
  String title;
  String value;
  // List<dynamic> attributes_product;
  dynamic documents_product;
  List<ProductModel> attach_products;

  ProductInfoTab({
    this.type,
    this.title,
    // this.value,
    this.attach_products,
    this.documents_product,
  });

  factory ProductInfoTab.fromJson(Map<String, dynamic> json) {
    return ProductInfoTab(
      type: json['type'] == null ? null : json['type'],
      title: json['title'] == null ? null : json['title'],
      // value: json['value'] = null ? null : json['value'],
      attach_products: json['attach_products'] == null
          ? null
          : List<ProductModel>.from(json['attach_products'].map((x) {
              return ProductModel.fromJson(x);
            })),
    );
  }
}

class AttributeProduct {
  String name;
  String value;

  AttributeProduct({
    this.name,
    this.value,
  });

  factory AttributeProduct.fromJson(Map<String, dynamic> json) {
    return AttributeProduct(
      name: json['name'],
      value: json['value'],
    );
  }
}

class FavoriteResponse {
  int code;
  FavoriteData data;
  String message;

  FavoriteResponse({this.code, this.data, this.message});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      FavoriteResponse(
          code: json['code'] ?? null,
          data: json['data'] == null
              ? FavoriteData()
              : FavoriteData.fromJson(json['data']),
          message: json['message']);
}

class FavoriteData {
  bool isWishlist;
  String message;

  FavoriteData({this.isWishlist, this.message});

  factory FavoriteData.fromJson(Map<String, dynamic> json) => FavoriteData(
        isWishlist: json['is_wishlist'],
        message: json['message'],
      );
}
