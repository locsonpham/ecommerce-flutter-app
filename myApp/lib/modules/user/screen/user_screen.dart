import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/order/screen/order_list_screen.dart';
import 'package:http_request/modules/recent_view/screen/recentview_screen.dart';
import 'package:http_request/modules/wishlist/screen/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserInfo _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = new UserInfo();
    _user.name = "";
    _user.avatar = null;
    _user.phone = "";
    _user.address = "";
    _user.address1 = "";
    _user.email = "";
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tài khoản"),
      ),
      body: _bodyBuidler(),
    );
  }

  Future<bool> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user.name = prefs.getString('user_name') ?? "";
      _user.avatar = prefs.getString('user_avatar') ?? null;
      _user.phone = prefs.getString('user_phone') ?? "";
      _user.address = prefs.getString('user_address') ?? "";
      _user.address1 = prefs.getString('user_address1') ?? "";
      _user.email = prefs.getString('user_email') ?? "";
    });
    return true;
  }

  Future<bool> _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }

  Widget _bodyBuidler() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: (_user.avatar == null)
                                    ? AssetImage('assets/default_avatar.png')
                                    : NetworkImage(_user.avatar),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _user.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    _user.email,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  )
                                ],
                              ),
                            )),
                        Icon(Icons.arrow_right),
                      ],
                    )),
              ),
              Container(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderListScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Đơn hàng"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ),
              Container(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.contacts),
                    title: Text("Yêu cầu khảo sát và báo giá"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ),
              Container(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishListScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Yêu thích của tôi"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ),
              Container(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecentViewScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.visibility),
                    title: Text("Sản phẩm vừa xem"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ),
              Container(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Đánh giá dịch vụ"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ),
              Container(height: 1, color: Colors.grey),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
