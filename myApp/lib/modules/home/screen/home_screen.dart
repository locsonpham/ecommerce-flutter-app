import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_request/data/data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http_request/modules/auth/screen/login_screen.dart';
import 'package:http_request/modules/auth/screen/register_screen.dart';
import 'package:http_request/modules/cart/bloc/cart_bloc.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product/screen/products_screen.dart';
import 'package:http_request/modules/home/bloc/home_bloc.dart';
import 'package:http_request/modules/promotion/screen/promotion_screen.dart';
import 'package:http_request/modules/user/screen/user_screen.dart';
import 'package:http_request/modules/widget/cart_widget.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';
import 'package:http_request/utils/number_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../networking/response.dart';
import '../model/home_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;
  CartBloc _cartBloc;
  var _selectedIndex = 0;
  String _access_token;
  bool _isUserExist = false;
  int cartTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeBloc = new HomeBloc();
    _cartBloc = new CartBloc();
    getAccessToken();
    _cartBloc.getCartTotal().then((value) {
      setState(() {
        cartTotal = value;
      });
    });
  }

  Future<bool> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _access_token = (prefs.getString('access_token') ?? null);
    if (_access_token != null)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: _bodyBuilder(context),
        bottomNavigationBar: _buildBottomNav(
          context,
        ));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
      ),
      // title: TextBox(),
      actions: <Widget>[
        // Search
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/search");
          },
          icon: Icon(Icons.search),
        ),
        // Phone
        IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {},
        ),
        // Cart
        IconButton(
          icon: cartWidget(context, cartTotal),
          onPressed: () {},
        )
      ],
    );
  }

  void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });
    if (index == 3) {
      Navigator.pushNamed(context, "/cart");
    }
    if (index == 4) {
      getAccessToken().then((isExist) {
        if (isExist == false) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserScreen()));
        }
      });
    }
  }

  static const List<Widget> _screenOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Tin nhan',
    ),
    Text(
      'Index 3: Thong bao',
    ),
    Text(
      'Index 4: Gio hang',
    ),
    Text(
      'Index 5: Tai khoan',
    ),
  ];

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[500],
      onTap: _onItemTapped,
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return _buildHome(context);
    // return Container(child: _screenOptions.elementAt(_selectedIndex));
  }

  Widget _buildHome(BuildContext context) {
    return Container(
      child: StreamBuilder<Response<HomeModel>>(
        stream: _homeBloc.homeDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return loadingScreen2();
              case Status.COMPLETED:
                // return loadingScreen();
                return _homeScreen(context, snapshot);
              case Status.ERROR:
                return Container();
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _homeScreen(BuildContext context, AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _slider(snapshot.data.data.sliders),
          _txtService(),
          _blockService(snapshot.data.data.services),
          _txtCategory(),
          _blockCategory(snapshot.data.data.categories),
          _txtHighlight(),
          _blockHighlight(snapshot.data.data.highlights),
          _txtPromotion(),
          _blockPromotion(snapshot.data.data.promotions),
        ],
      ),
    );
  }

  Widget _slider(dynamic data) {
    if (data == null) return Container();
    var arrSliderImages = List();

    data.forEach((_slider) {
      arrSliderImages.add(NetworkImage(_slider.image));
    });

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 10)
      ]),
      child: SizedBox(
          height: 150.0,
          // width: 300.0,
          child: Carousel(
            boxFit: BoxFit.cover,
            borderRadius: true,
            radius: Radius.circular(10),
            images: arrSliderImages,
          )),
    );
  }

  Widget _txtService() {
    return ListTile(
      leading: Icon(
        Icons.security,
        color: Colors.redAccent,
      ),
      title: Text(
        "Dịch vụ cảnh báo",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _blockService(dynamic data) {
    if (data == null) return Container();

    return Container(
      // color: Colors.red,
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Container(
                        width: 200,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset.zero,
                                  blurRadius: 10)
                            ],
                            border: Border.all(color: Colors.grey, width: 0.3),
                            image: DecorationImage(
                                image: NetworkImage(data[index].image),
                                fit: BoxFit.cover)),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.blue,
                      child: Text(
                        data[index].title,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _txtCategory() {
    return ListTile(
      leading: Icon(
        Icons.category,
        color: Colors.orangeAccent,
      ),
      title: Text(
        "Danh mục sản phẩm",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _blockCategory(List<HomeCategoryModel> data) {
    num _countValue = 2;
    num _aspectWidth = 2;
    num _aspectHeight = 3;

    if (data == null) return Container();

    return Container(
      // primary: true,
      child: Container(
          // height: 500,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: (_aspectHeight / _aspectWidth),
                crossAxisCount: _countValue,
                children: List.generate(
                    data.length,
                    (index) => Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            // borderRadius: BorderRadius.circular(8),
                            // border:
                            //     Border.all(color: Colors.grey[300], width: 0.2),
                            ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsScreen(
                                        data[index].category_id,
                                        data[index].name,
                                      )),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    width: 200,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: NetworkImage(data[index].image),
                                    )),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      child: Text(
                                    data[index].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.values[2],
                                    ),
                                  )))
                            ],
                          ),
                        ))),
              )
            ],
          )),
    );
  }

  Widget _txtHighlight() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        bottom: 20,
        right: 10,
      ),
      child: Row(
        children: <Widget>[
          Text('Sản phẩm ',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontFamily: '',
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          Text(
            'Nổi bật',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockHighlight(dynamic data) {
    if (data == null) return Container();
    List<ProductModel> _products = data;

    return Container(
      // color: Colors.red,
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _products.length,
          itemBuilder: (BuildContext context, int index) {
            return productWidget(context, _products[index]);
          }),
    );
  }

  Widget _txtPromotion() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      child: Row(
        children: <Widget>[
          Text('Sản phẩm ',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontFamily: '',
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          Text(
            'Khuyến mại',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 100),
              child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.3,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          offset: Offset.zero,
                          blurRadius: 10)
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromotionListScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _blockPromotion(dynamic data) {
    if (data == null) return Container();
    List<ProductModel> _products = data;

    return Container(
      // color: Colors.red,
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _products.length,
          itemBuilder: (BuildContext context, int index) {
            return productWidget(context, _products[index]);
          }),
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/search");
      },
      child: Container(
        height: 35,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
