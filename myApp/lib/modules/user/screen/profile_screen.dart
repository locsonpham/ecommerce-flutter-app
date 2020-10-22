import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/modules/home/screen/home_screen.dart';
import 'package:http_request/modules/order/screen/order_list_screen.dart';
import 'package:http_request/modules/recent_view/screen/recentview_screen.dart';
import 'package:http_request/modules/user/bloc/profile_bloc.dart';
import 'package:http_request/modules/wishlist/screen/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo _user;
  ProfileBloc _bloc;
  TextEditingController _nameInputController;
  TextEditingController _emailInputController;
  TextEditingController _phoneInputController;
  TextEditingController _addressInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = ProfileBloc();

    _user = new UserInfo();
    _user.name = "";
    _user.avatar = null;
    _user.phone = "";
    _user.address = "";
    _user.address1 = "";
    _user.email = "";
    _loadUserData();
    _nameInputController = TextEditingController(text: _user.name);
    _emailInputController = TextEditingController(text: _user.email);
    _phoneInputController = TextEditingController(text: _user.phone);
    _addressInputController = TextEditingController(text: _user.address);
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

      _nameInputController.text = _user.name;
      _phoneInputController.text = _user.phone;
      _addressInputController.text = _user.address;
    });
    return true;
  }

  Future<bool> _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
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
                        controller: _nameInputController,
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
                        controller: _phoneInputController,
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
                        controller: _addressInputController,
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
                    Navigator.pushNamed(context, "/mainScreen");
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
                onTap: () {
                  updateUserProfile();
                },
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

  void updateUserProfile() {
    var params = Map<String, dynamic>();
    params["name"] = (_nameInputController.value.text.isEmpty)
        ? ""
        : _nameInputController.value.text;
    // params["email"] = (_emailInputController.value.text == null)
    //     ? ""
    //     : _phoneInputController.value.text;
    params["phone"] = (_phoneInputController.value.text.isEmpty)
        ? ""
        : _addressInputController.value.text;
    params["name"] = (_addressInputController.value.text.isEmpty)
        ? ""
        : _addressInputController.value.text;

    _bloc.updateUserProfile(params).then((value) => null);
  }
}
