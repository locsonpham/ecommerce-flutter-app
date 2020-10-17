import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email;
  String name;
  String password;
  String phone;
  bool isValid = false;
  bool _showPassword = false;

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Center(child: Text('Đăng ký')),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              txtDisplay('EMAIL*'),
              txtEmail(),
              txtDisplay('HỌ VÀ TÊN*'),
              txtName(),
              txtDisplay('MẬT KHẨU*'),
              txtPassword(),
              txtDisplay('SỐ ĐIỆN THOẠI*'),
              txtPhone(),
              btnSignup(),
              socialLogin()
            ],
          )),
        ));
  }

  Widget txtDisplay(String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 10),
        child: Align(alignment: Alignment.centerLeft, child: Text(text)));
  }

  Widget txtEmail() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              labelText: 'Nhập email',
              hintText: ''),
          onChanged: (text) {
            setState(() {
              // print('Email: ' + text);
              email = text;
              // isValid = !email.isEmpty;
            });
          },
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ));
  }

  Widget txtName() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              labelText: 'Nhập họ và tên',
              hintText: 'Input your name'),
          onChanged: (text) {
            setState(() {
              // print('Email: ' + text);
              name = text;
              // isValid = !email.isEmpty;
            });
          },
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ));
  }

  Widget txtPassword() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: TextFormField(
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent)),
            labelText: 'Nhập mật khẩu',
            hintText: 'Input your password',
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
          onChanged: (text) {
            password = text;
            // print('Password: ' + text);
          },
          obscureText: _showPassword,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
        ));
  }

  Widget txtPhone() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              labelText: 'Nhập số điện thoại',
              hintText: 'Input your phone'),
          onChanged: (text) {
            setState(() {
              // print('Email: ' + text);
              name = text;
              // isValid = !email.isEmpty;
            });
          },
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your phone';
            }
            return null;
          },
        ));
  }

  Widget socialLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
          child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                  // alignment: Alignment.center,
                  child: Center(child: Text('Đăng ký nhanh với:')))),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [fbLogin(), ggLogin()],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget fbLogin() {
    return GestureDetector(
      onTap: () {
        print('fb login');
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 50,
          height: 50,
          child: Image(
              image: new AssetImage('assets/icons/ic_facebook.png'),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget ggLogin() {
    return GestureDetector(
      onTap: () {
        print('gg login');
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 50,
          height: 50,
          child: Image(
              image: new AssetImage('assets/icons/ic_google.png'),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget btnSignup() {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.orangeAccent),
          child: Center(
            child: Text("Đăng ký"),
          )),
    );
  }
}
