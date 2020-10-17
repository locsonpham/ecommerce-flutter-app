import 'package:flutter/material.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/modules/cart/model/cart_model.dart';
import 'package:http_request/modules/order/bloc/order_bloc.dart';
import 'package:http_request/modules/order/model/order_model.dart';
import 'package:http_request/modules/order/screen/order_detail_screen.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/utils/string_utils.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  OrderBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new OrderBloc();
    _bloc.getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đơn hàng")),
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
    var orders = List();
    orders = snapshot.data.data.data;

    if (orders.length == 0) {
      return Center(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Bạn chưa có đơn hàng nào"),
            ),
          ],
        )),
      );
    }

    return Stack(
      children: <Widget>[
        CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _orderList(context, snapshot),
            SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(bottom: 180),
            )),
          ],
        ),
      ],
    );
  }

  Widget _orderList(BuildContext context, AsyncSnapshot snapshot) {
    List<OrderDetailModel> _orderList;

    if (snapshot.data.data == null) return SliverToBoxAdapter();

    var response = snapshot.data.data.data;

    _orderList = List<OrderDetailModel>.from(response.map((x) {
      return OrderDetailModel.fromJson(x);
    }));

    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _orderItem(_orderList[index]);
      },
      childCount: _orderList.length,
    ));
  }

  Widget _orderItem(OrderDetailModel order) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order.orderId)));
      },
      child: Container(
        // height: 120,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[400]),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.book,
                  color: Colors.grey,
                )),
            Expanded(
              flex: 7,
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Text("Đơn hàng: "),
                            Text(
                              "#${order.orderId.toString()}",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Tổng tiền: "),
                          Text(
                            formatCurrencyD(order.totalAmount.toDouble()),
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        order.createdAt,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            Text("Trạng thái: "),
                            Text(
                              order.status.toString(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
                child: Icon(
              Icons.arrow_right,
              color: Colors.grey,
            ))
          ],
        ),
      ),
    );
  }
}
