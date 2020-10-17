import 'package:flutter/material.dart';
import 'package:http_request/modules/order/bloc/order_bloc.dart';
import 'package:http_request/modules/order/model/order_model.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';

import 'order_detail_screen.dart';

class CheckOutScreen extends StatefulWidget {
  OrderInfo order;

  CheckOutScreen(this.order);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  OrderBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = OrderBloc();
    _bloc.orderAction(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt hàng"),
      ),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return StreamBuilder<Response<ServerResponse>>(
      stream: _bloc.orderStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              {
                return loadingScreen2();
              }
            case Status.COMPLETED:
              {
                return _checkoutInfo(context, snapshot);
              }
            case Status.ERROR:
              {
                return Container(
                  child: Text(snapshot.error),
                );
              }
          }
        }
        return Container();
      },
    );
  }

  Widget _checkoutInfo(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Image(
            height: 50,
            image: AssetImage("assets/success.png"),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Đặt hàng thành công"),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Mã đơn hàng #${snapshot.data.data.data["order_id"]}",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                "Cảm ơn quý khách đã đặt hàng. Nhân viên chúng tôi sẽ gọi lại để xác nhận đơn hàng."),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
            color: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Tiếp tục mua sắm"),
            ),
          ),
          RaisedButton(
            onPressed: () {
              ;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(
                          snapshot.data.data.data["order_id"])));
            },
            color: Colors.orangeAccent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Theo dõi đơn hàng"),
            ),
          )
        ],
      ),
    );
  }
}
