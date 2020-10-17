import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product_detail/bloc/product_detail_bloc.dart';
import 'package:http_request/modules/product_detail/model/product_detail_model.dart';
import 'package:http_request/modules/recent_view/bloc/recentview_bloc.dart';
import 'package:http_request/modules/widget/cart_widget.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';
import 'package:http_request/utils/number_format.dart';
import 'package:http_request/utils/showAlert.dart';
import 'package:http_request/utils/string_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  int product_id;

  ProductDetailScreen(this.product_id);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailBloc _bloc;
  CartBloc _cartBloc;
  RecentViewBloc _recentViewBloc;
  int quantity = 1;
  bool _isFavorite = false;
  int cartTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new ProductDetailBloc();
    _cartBloc = new CartBloc();
    _recentViewBloc = RecentViewBloc();
    _bloc.fetchProductDetailById(widget.product_id);
    _bloc.getFavorite(widget.product_id).then((result) {
      if (result.code == 200) {
        setState(() {
          _isFavorite = result.data.isWishlist;
        });
      }
    });

    _updateTotalQuantity();
  }

  // CustomScrollView
  // sliverAppbar
  // List Tile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: Text("Chi tiết sản phẩm"),
      //     ),
      body: _bodyBuilder(context),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return StreamBuilder<Response<ProductDetailModel>>(
      stream: _bloc.productDetailDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return loadingScreen2();
            case Status.COMPLETED:
              return _displayProduct(context, snapshot);
            case Status.ERROR:
              return Container(
                child: Text(snapshot.data.message),
              );
          }
        }
        return Container();
      },
    );
  }

  Widget _displayProduct(BuildContext context, AsyncSnapshot snapshot) {
    ProductDetailModel _product = snapshot.data.data;
    _recentViewBloc.setRecentProduct(_product);

    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 380.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Material(
              child: Image(
                image: NetworkImage(formatImageUrl(_product.image)),
              ),
            ),
          ),
          actions: <Widget>[
            // Cart
            IconButton(
              icon: cartWidget(context, cartTotal),
              onPressed: () {},
            )
          ],
        ),
        _productInfo(context, snapshot),
        _quantityInput(context),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        _productInfoTabs(snapshot.data.data.product_info_tabs),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        _ratingTab(),
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 20,
        //   ),
        // ),
        _relativeTab(_product.related_products),
      ],
    );
  }

  Widget _productInfo(BuildContext context, AsyncSnapshot snapshot) {
    ProductDetailModel _product = snapshot.data.data;
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: ListTile(
                  title: Text(
                    _product.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      _checkFavorite(_product.product_id);
                    },
                    child: Icon(
                      Icons.favorite,
                      color: (_isFavorite) ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${moneyFormat.moneyVNDFormat(_product.price)}đ",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Model: ${_product.sku}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Kho hàng: Còn ${_product.stock} sản phẩm",
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
            ],
          )),
    );
  }

  void _checkFavorite(int product_id) {
    _bloc.setFavorite(product_id).then((result) {
      if (result.code == null) {
        Navigator.pushNamed(context, "/login");
      }
      if (result.code == 200) {
        setState(() {
          _isFavorite = result.data.isWishlist;
        });
        showAlert(context, "Message", result.data.message);
      }
    });
  }

  Widget _quantityInput(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          height: 60,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Số lượng:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                width: 40,
                child: RaisedButton(
                  onPressed: () {
                    _decreaseQuantity();
                  },
                  child: Text("-"),
                ),
              ),
              Container(
                width: 50,
                height: 38,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.grey)),
                child: Center(child: Text("${quantity}")),
              ),
              Container(
                width: 40,
                child: RaisedButton(
                  onPressed: () {
                    _increaseQuantity();
                  },
                  child: Text("+"),
                ),
              ),
            ],
          )),
    );
  }

  void _increaseQuantity() {
    setState(() {
      quantity += 1;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      quantity == 1 ? quantity = 1 : quantity -= 1;
    });
  }

  Widget _productInfoTabs(List<ProductInfoTab> tabs) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: Text(tabs[index].title),
                  trailing: Icon(Icons.arrow_right),
                )));
      },
      childCount: tabs.length,
    ));

    // return SliverList(
    //     delegate: SliverChildListDelegate(List<Widget>.from(tabs.map((tab) {
    //   return Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         border: Border.all(),
    //         color: Colors.white,
    //       ),
    //       child: ListTile(
    //         title: Text(tab.title),
    //         trailing: Icon(Icons.arrow_right),
    //       ));
    // }))));
  }

  Widget _ratingTab() {
    return SliverToBoxAdapter(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Đánh giá',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('Đánh giá ngay'),
                      ))
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text('Mua hàng để đánh giá ngay'),
              ),
            ],
          )),
    );
  }

  Widget _relativeTab(List<ProductModel> products) {
    if (products == null) return SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              // decoration: BoxDecoration(color: Colors.white),
              child: Text(
                "Sản phẩm liên quan",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              // color: Colors.red,
              height: 280,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return productWidget(context, products[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InkWell(
                child: Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Colors.orange,
                  ),
                  Text(
                    "Chat ngay",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            )),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: () {
                  _addToCart(widget.product_id, quantity);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.orange,
                      ),
                      Text(
                        "Thêm vào giỏ hàng",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.red,
              child: InkWell(
                onTap: () {
                  _buyNow(widget.product_id, quantity);
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text(
                    "Mua ngay",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _updateTotalQuantity() {
    _cartBloc.getCartTotal().then((result) {
      // print(result);
      setState(() {
        cartTotal = result;
      });
    });
  }

  void _addToCart(int productId, int quantity) async {
    _cartBloc.addCart(productId, quantity).then((result) {
      if (result.code == 200) {
        showAlert(
            context, "Thông báo", "Đã thêm ${quantity} sản phẩm vào giỏ hàng");
        // setState(() {
        //   totalCartQuantity = result.data["cart_total"];
        // });
      }
      _updateTotalQuantity();
    });
  }

  void _buyNow(int productId, int quantity) async {
    _cartBloc.addCart(productId, quantity).then((result) {
      if (result.code == 200) {
        Navigator.pushNamed(context, "/buynow");
      }
    });
  }
}
