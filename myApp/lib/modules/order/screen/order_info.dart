import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/modules/order/bloc/order_bloc.dart';
import 'package:http_request/modules/order/model/order_model.dart';
import 'package:http_request/modules/order/screen/order_status.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutInfoScreen extends StatefulWidget {
  @override
  _CheckOutInfoScreenState createState() => _CheckOutInfoScreenState();
}

class _CheckOutInfoScreenState extends State<CheckOutInfoScreen> {
  CartBloc _bloc;
  OrderBloc _orderBloc;
  UserInfo _user;
  var _commentController = TextEditingController();
  List<CartModel> _cartList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new CartBloc();
    _orderBloc = new OrderBloc();
    _bloc.getCartList();
    _user = new UserInfo();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user.name = prefs.getString('user_name') ?? "";
      _user.avatar = prefs.getString('user_avatar') ?? null;
      _user.phone = prefs.getString('user_phone') ?? "";
      _user.address = prefs.getString('user_address') ?? "";
      _user.address1 = prefs.getString('user_address1') ?? "";
      _user.email = prefs.getString('user_email') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin đơn hàng")),
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
    return Stack(
      children: <Widget>[
        CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _customerInfo(),
            _cartItemList(context, snapshot),
            _orderMessage(),
            SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(bottom: 200),
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
                  var order = OrderInfo(
                    customer: new CustomerInfo(),
                    products: new List<CartModel>(),
                  );
                  order.customer.name = _user.name;
                  order.customer.phone = _user.phone;
                  order.customer.address =
                      (_user.address == null) ? "" : _user.address;
                  order.customer.comment =
                      (_commentController.value.text == null)
                          ? ""
                          : _commentController.value.text;
                  order.products = (_cartList.isNotEmpty) ? _cartList : [];

                  checkoutAction(order);

                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CheckOutScreen(order)));
                },
                child: Container(
                  height: 50,
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      "Đặt hàng",
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

  void checkoutAction(OrderInfo orderInfo) {
    _orderBloc.checkoutAction(orderInfo).then((response) {
      // print(response);
      if (response.code == 200) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CheckOutScreen(
                      res: response,
                    )));
      }
    });
  }

  Widget _customerInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text("Thông tin nhận hàng",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      _user.name,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      _user.phone,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  (_user.address != "")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            _user.address,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                          ),
                        )
                      : Container(),
                  (_user.address1 != "")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            _user.address1,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _orderMessage() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        height: 80,
        child: TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent)),
            labelText: 'Tin nhắn: ',
          ),
          onChanged: (value) {},
          onEditingComplete: () {},
          onFieldSubmitted: (value) {},
        ),
      ),
    );
  }

  Widget _cartItemList(BuildContext context, AsyncSnapshot snapshot) {
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
      height: 100,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {},
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            formatCurrencyD(item.price.toDouble()),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.red, fontSize: 16),
                          ),
                          Text(" x${item.quantity}"),
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
