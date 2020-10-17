import 'package:flutter/material.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/utils/string_utils.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new CartBloc();
    _bloc.getCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giỏ hàng")),
      body: StreamBuilder<Response<ServerResponse>>(
          stream: _bloc.cartStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return loadingScreen2();
                case Status.COMPLETED:
                  return _bodyBuilder(context, snapshot);
                case Status.ERROR:
                  return Container(
                    child: Text(snapshot.error),
                  );
              }
            }
            return Container();
          }),
    );
  }

  Widget _bodyBuilder(BuildContext context, AsyncSnapshot snapshot) {
    var products = List();
    products = snapshot.data.data.data["products"];

    if (products.length == 0) {
      return Center(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Bạn không có sản phẩm nào trong giỏ hàng"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              color: Colors.blueAccent,
              child: Text("Tiếp tục mua sắm"),
            )
          ],
        )),
      );
    }

    return Stack(
      children: <Widget>[
        CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _cartItemList(context, snapshot),
            SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(bottom: 180),
            )),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: <Widget>[
              _cartGrandTotal(context, snapshot),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/buynow");
                },
                child: Container(
                  height: 50,
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      "Tiếp tục",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cartItemList(BuildContext context, AsyncSnapshot snapshot) {
    List<CartModel> _cartList;

    if (snapshot.data.data.data["products"] == null)
      return SliverToBoxAdapter();

    var _products = snapshot.data.data.data["products"];

    _cartList =
        List<CartModel>.from(_products.map((x) => CartModel.fromJson(x)));

    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _cartItem(_cartList[index]);
      },
      childCount: _cartList.length,
    ));
  }

  Widget _cartItem(CartModel item) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ProductDetailScreen(item.productId)));
              },
              child: Container(
                height: 120,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Image(
                  image: NetworkImage(formatImageUrl(item.image)),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
                margin: EdgeInsets.only(left: 10),
                // color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                            )),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.blue[500],
                            ),
                            onPressed: () {
                              _bloc.removeCart(item.cartId);
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatCurrencyD(item.price.toDouble()),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.red, fontSize: 16),
                          ),
                          Container(
                            width: 100,
                            height: 30,
                            // color: Colors.red,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey)),
                                  child: InkWell(
                                    onTap: () {
                                      _decreaseQuantity(
                                          item.cartId, item.quantity);
                                    },
                                    child: Center(child: Text("-")),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey)),
                                  child: Center(
                                      child: Text(item.quantity.toString())),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey)),
                                  child: InkWell(
                                    onTap: () {
                                      _increaseQuantity(
                                          item.cartId, item.quantity);
                                    },
                                    child: Center(child: Text("+")),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _decreaseQuantity(String cartId, int quantity) {
    if (quantity > 1) quantity -= 1;
    _bloc.updateCart(cartId, quantity);
  }

  void _increaseQuantity(String cartId, int quantity) {
    quantity++;
    _bloc.updateCart(cartId, quantity);
  }

  Widget _cartGrandTotal(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data.data.data["grand_total"] == null) return Container();

    int _grandTotal = snapshot.data.data.data["grand_total"];

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Phí vận chuyển",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "0đ",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tổng tiền",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  formatCurrencyD(_grandTotal.toDouble()),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
