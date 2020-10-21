import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/screen/login_screen.dart';
import 'package:http_request/modules/auth/screen/register_screen.dart';
import 'package:http_request/modules/cart/screen/cart_screen.dart';
import 'package:http_request/modules/order/screen/order_info.dart';
import 'package:http_request/modules/order/screen/order_status.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/modules/product/screen/products_screen.dart';
import 'package:http_request/modules/search/screen/search_screen.dart';
import 'package:http_request/modules/splash_screen/screen/splash_screen.dart';
import 'package:http_request/modules/user/screen/user_screen.dart';
import 'package:http_request/utils/bottom_navigation_bar.dart';

import 'modules/main_screen/screen/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xFF30C591),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/mainScreen": (context) => new bottomNavigationBar(),
        "/home": (context) => HomeScreen(),
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/user": (context) => UserScreen(),
        "/search": (context) => SearchScreen(),
        "/cart": (context) => CartScreen(),
        "/buynow": (context) => CheckOutInfoScreen(),
      },
    );
  }
}
