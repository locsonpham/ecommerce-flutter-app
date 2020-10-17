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

class OrderDetailScreen extends StatefulWidget {
  int orderId;

  OrderDetailScreen(this.orderId);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderBloc _bloc;
  List<CartModel> _cartList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new OrderBloc();
    _bloc.getOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Thông tin đơn hàng"))),
      body: StreamBuilder<Response<ServerResponse>>(
          stream: _bloc.orderStream,
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
    var order = OrderDetailModel.fromJson(snapshot.data.data.data);

    return Stack(
      children: <Widget>[
        CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _orderInfo(order),
            _customerInfo(order),
            _orderItemList(order),
            _cartGrandTotal(order),
            SliverToBoxAdapter(
                child: Container(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                onPressed: () {},
                color: Colors.blue,
                child: Text(
                  "Theo dõi đơn hàng",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }

  Widget _orderInfo(OrderDetailModel order) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.orangeAccent,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                Icons.card_travel,
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Text("Mã đơn hàng: #${order.orderId}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 16, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    child: Text(
                        (order.status == 1)
                            ? "Trạng thái: Đang xử lý"
                            : "Trạng thái: Đã hoàn thành",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 15, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    child: Text(
                        (order.status == 1)
                            ? "Hệ thống đang xử lý đơn hàng"
                            : "Đã hoàn thành",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 15, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      order.createdAt,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _customerInfo(OrderDetailModel order) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                Icons.location_on,
                color: Colors.green,
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
                      "Tên: " + order.name,
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
                      "SDT: " + order.phone,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  (order.address != "")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Địa chỉ: " + order.address,
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

  Widget _orderItemList(OrderDetailModel order) {
    var _products = order.products;

    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _orderItem(_products[index]);
      },
      childCount: _products.length,
    ));
  }

  Widget _orderItem(CartModel item) {
    return Container(
      height: 120,
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
                        Container(
                            width: 260,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatCurrencyD(item.price.toDouble()),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.red, fontSize: 16),
                          ),
                          Text(" SL:${item.quantity}"),
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

  Widget _cartGrandTotal(OrderDetailModel order) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Phí vận chuyển",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                  Text(
                    formatCurrencyD(order.feeShip.toDouble()),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tổng thanh toán",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                  Text(
                    formatCurrencyD(order.totalAmount.toDouble()),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
      ),
    );
  }
}
