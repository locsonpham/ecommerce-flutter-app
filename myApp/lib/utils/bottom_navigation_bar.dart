import 'package:flutter/material.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/base/share_reference_manager.dart';
import 'package:http_request/modules/cart/screen/cart_screen.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/user/screen/user_screen.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  String _token;
  CartBloc _cartBloc;
  int _cartTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartBloc = CartBloc();
    _cartBloc.getCartTotal().then((value) {
      setState(() {
        _cartTotal = value;
      });
    });
  }

  int currentIndex = 0;

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return HomeScreen();
      case 3:
        return CartScreen();
      case 4:
        return UserScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.home),
              ),
              title: Text('Trang chủ'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.message),
              ),
              title: Text('Tin nhắn'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.notifications),
              ),
              title: Text('Thông báo'),
            ),
            BottomNavigationBarItem(
              icon: cartTotal(_cartTotal),
              title: Text('Giỏ hàng'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.account_circle),
              ),
              title: Text('Tài khoản'),
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.green[500],
          onTap: (value) {
            currentIndex = value;
            if (value == 4) {
              getAccessToken().then((token) {
                if (token == null) {
                  // _token = token;
                  // setState(() {});
                  Navigator.pushNamed(context, "/login");
                } else
                  setState(() {});
              });
            } else {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  Widget cartTotal(int total) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.shopping_cart),
          ),
          (total > 0)
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        total.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
