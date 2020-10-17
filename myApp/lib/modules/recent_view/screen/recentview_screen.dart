import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product_detail/bloc/product_detail_bloc.dart';
import 'package:http_request/modules/product_detail/model/product_detail_model.dart';
import 'package:http_request/modules/product_detail/service/product_detail_service.dart';
import 'package:http_request/modules/recent_view/bloc/recentview_bloc.dart';
import 'package:http_request/modules/search/bloc/search_bloc.dart';
import 'package:http_request/modules/search/model/search_model.dart';
import 'package:http_request/modules/wishlist/bloc/wishlist_bloc.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';
import 'package:http_request/utils/showAlert.dart';

class RecentViewScreen extends StatefulWidget {
  @override
  _RecentViewScreenState createState() => _RecentViewScreenState();
}

class _RecentViewScreenState extends State<RecentViewScreen> {
  RecentViewBloc _bloc;
  ProductDetailService _productService;
  List<ProductModel> _products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = RecentViewBloc();
    _products = List<ProductModel>();
    _bloc.getRecentProduct().then((productsJson) {
      setState(() {
        _products = List<ProductModel>.from(
            productsJson.map((x) => ProductModel.fromJson(jsonDecode(x))));
        // print(_products);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm vừa xem")),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Center(
        child: Column(
          children: <Widget>[
            _displayProduct(context),
          ],
        ),
      )),
    );
  }

  Widget _displayProduct(BuildContext context) {
    num _countValue = 2;
    num _aspectWidth = 2;
    num _aspectHeight = 1.5;

    if (_products.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Chưa xem gì",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Container(
      child: Container(
          // height: 1000,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: (_aspectHeight / _aspectWidth),
                crossAxisCount: _countValue,
                children: List.generate(
                  _products.length,
                  (index) => productWidget(context, _products[index]),
                ),
              )
            ],
          )),
    );
  }
}
