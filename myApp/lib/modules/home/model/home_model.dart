import 'package:http_request/modules/product/model/product_model.dart';

const hostUrl = 'https://trongnv.me';

class HomeModel {
  List<HomeSliderModel> sliders;
  List<HomeServiceModel> services;
  List<HomeCategoryModel> categories;
  List<ProductModel> highlights;
  List<ProductModel> promotions;

  HomeModel({
    this.sliders,
    this.services,
    this.categories,
    this.highlights,
    this.promotions,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      sliders: json["data"]["sliders"] == null
          ? []
          : List<HomeSliderModel>.from(
              json["data"]["sliders"].map((x) => HomeSliderModel.fromJson(x))),
      services: json["data"]["services"] == null
          ? []
          : List<HomeServiceModel>.from(json["data"]["services"]
              .map((x) => HomeServiceModel.fromJson(x))),
      categories: json["data"]["categories"] == null
          ? []
          : List<HomeCategoryModel>.from(json["data"]["categories"]
              .map((x) => HomeCategoryModel.fromJson(x))),
      highlights: json["data"]["highlight_products"] == null
          ? []
          : List<ProductModel>.from(json["data"]["highlight_products"]
              .map((x) => ProductModel.fromJson(x))),
      promotions: json["data"]["promotion_products"] == null
          ? []
          : List<ProductModel>.from(json["data"]["promotion_products"]
              .map((x) => ProductModel.fromJson(x))),
    );
  }
}

class HomeServiceModel {
  int id;
  String title;
  String image;
  HomeServiceModel({this.id, this.title, this.image});

  factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
    return HomeServiceModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class HomeCategoryModel {
  int category_id;
  String name;
  String image;
  HomeCategoryModel({this.category_id, this.name, this.image});

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      category_id: json['category_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class HomeSliderModel {
  int id;
  String title;
  String image;

  HomeSliderModel({this.id, this.title, this.image});

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) {
    return HomeSliderModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class HomeHighlightModel {
  int product_id;
  String name;
  String image;
  int price;
  int rating_score;

  HomeHighlightModel({
    this.product_id,
    this.name,
    this.image,
    this.price,
    this.rating_score,
  });

  factory HomeHighlightModel.fromJson(Map<String, dynamic> json) {
    return HomeHighlightModel(
      product_id: json['product_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
      price: json['price'] as int,
      rating_score: json['rating_score'] as int,
    );
  }
}

class HomePromotionModel {
  int product_id;
  String name;
  String image;
  int price;
  int percent_discount;
  int rating_score;

  HomePromotionModel({
    this.product_id,
    this.name,
    this.image,
    this.price,
    this.percent_discount,
    this.rating_score,
  });

  factory HomePromotionModel.fromJson(Map<String, dynamic> json) {
    return HomePromotionModel(
      product_id: json['product_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
      price: json['price'] as int,
      percent_discount: json['percent_discount'] as int,
      rating_score: json['rating_score'] as int,
    );
  }
}
