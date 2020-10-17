const hostUrl = 'https://trongnv.me';

class ServiceData {
  int id;
  String title;
  String image;
  ServiceData({this.id, this.title, this.image});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] as int,
      title: json['title'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class CategoryData {
  int categoryId;
  String name;
  String image;
  CategoryData({this.categoryId, this.name, this.image});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class UserSliderData {
  int id;
  String title;
  String image;

  UserSliderData({this.id, this.title, this.image});

  factory UserSliderData.fromJson(Map<String, dynamic> json) {
    return UserSliderData(
      id: json['id'] as int,
      title: json['title'] as String,
      image: hostUrl + json['image'] as String,
    );
  }
}

class HighlightData {
  int product_id;
  String name;
  String image;
  int price;
  int rating_score;

  HighlightData({
    this.product_id,
    this.name,
    this.image,
    this.price,
    this.rating_score,
  });

  factory HighlightData.fromJson(Map<String, dynamic> json) {
    return HighlightData(
      product_id: json['product_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
      price: json['price'] as int,
      rating_score: json['rating_score'] as int,
    );
  }
}

class PromotionData {
  int product_id;
  String name;
  String image;
  int price;
  int percent_discount;
  int rating_score;

  PromotionData({
    this.product_id,
    this.name,
    this.image,
    this.price,
    this.percent_discount,
    this.rating_score,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      product_id: json['product_id'] as int,
      name: json['name'] as String,
      image: hostUrl + json['image'] as String,
      price: json['price'] as int,
      percent_discount: json['percent_discount'] as int,
      rating_score: json['rating_score'] as int,
    );
  }
}
