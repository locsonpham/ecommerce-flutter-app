import 'package:flutter/material.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/utils/number_format.dart';
import 'package:http_request/utils/string_utils.dart';

Widget productWidget(BuildContext context, ProductModel product) {
  return Container(
    margin: EdgeInsets.all(10),
    width: 180,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 10)
      ],
      border: Border.all(color: Colors.grey, width: 0.3),
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product.product_id)),
        );
      },
      child: Stack(
        children: [
          _discountTag(product),
          _productInfo(product),
        ],
      ),
    ),
  );
}

Widget _discountTag(ProductModel product) {
  if (product.is_promotion == 1) {
    return Container(
      padding: EdgeInsets.all(0),
      height: 30,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), bottomRight: Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          '${product.percent_discount}%',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  } else {
    return Container();
  }
}

Widget _productInfo(ProductModel product) {
  int _salePrice;

  if (product.is_promotion == 1) {
    _salePrice =
        (product.price * (100 - product.percent_discount) / 100).toInt();
  }

  return Container(
    child: Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: FadeInImage(
              image: NetworkImage(formatImageUrl(product.image)),
              placeholder: AssetImage('assets/default_img.png'),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Text(
                        product.name,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  (product.is_promotion == 1)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                '${moneyFormat.moneyVNDFormat(_salePrice)}đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '${moneyFormat.moneyVNDFormat(product.price)}đ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                '${moneyFormat.moneyVNDFormat(product.price)}đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      children: [
                        // Text(
                        //   '${product.rating_score}',
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    ),
  );
}
