import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/order/screen/order_list_screen.dart';
import 'package:http_request/modules/recent_view/screen/recentview_screen.dart';
import 'package:http_request/modules/wishlist/screen/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text("Thông tin tài khoản"),
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
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Container(
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.only(top: 10, bottom: 20),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                        )),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: TextEditingController(text: _user.name),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Họ và tên",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        )),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: TextEditingController(text: _user.phone),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Số điện thoại",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.add_location,
                          color: Colors.grey,
                        )),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: TextEditingController(text: _user.address),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Địa chỉ",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey),
              SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.white54,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text("Đổi mật khẩu"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                ),
              ),
              Container(height: 3),
              Container(
                color: Colors.white54,
                child: InkWell(
                  onTap: () {
                    _clearUserData();
                    Navigator.push((context),
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Đăng xuất"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                          child: Text(
                        "Cập nhật",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
