import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/search/bloc/search_bloc.dart';
import 'package:http_request/modules/search/model/search_model.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';
import 'package:http_request/utils/showAlert.dart';

class SearchResultScreen extends StatefulWidget {
  String q;
  int p;

  SearchResultScreen(this.q, this.p);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  SearchBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = SearchBloc();
    _bloc.searchProduct(widget.q, widget.p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.q)),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Center(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Text(
            //     "Kết quả tìm kiếm với \"${widget.q}\"",
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            _searchResultDisplay(context),
          ],
        ),
      )),
    );
  }

  Widget _searchResultDisplay(BuildContext context) {
    return Container(
      child: StreamBuilder<Response<SearchResponse>>(
        stream: _bloc.searchDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return loadingScreen2();
              case Status.COMPLETED:
                return _productsScreen(context, snapshot);
              case Status.ERROR:
                return Container(
                  child: Text('error'),
                );
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _productsScreen(BuildContext context, AsyncSnapshot snapshot) {
    num _countValue = 2;
    num _aspectWidth = 2;
    num _aspectHeight = 1.5;

    List<ProductModel> _products =
        List<ProductModel>.from(snapshot.data.data.data["products"].map((x) {
      return ProductModel.fromJson(x);
    }));

    if (_products.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Không tìm thấy sản phẩm tương ứng",
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
