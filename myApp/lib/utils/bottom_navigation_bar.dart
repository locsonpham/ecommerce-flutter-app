import 'package:flutter/material.dart';
import 'package:http_request/base/share_reference_manager.dart';
import 'package:http_request/modules/cart/screen/cart_screen.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/user/screen/user_screen.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Trang chủ'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Tin nhắn'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Thông báo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Giỏ hàng'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Tài khoản'),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue[500],
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }

  Widget cartTotal() {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart),
          ),
          Positioned(
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
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
