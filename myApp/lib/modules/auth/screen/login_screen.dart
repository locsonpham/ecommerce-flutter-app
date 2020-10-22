import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http_request/modules/auth/bloc/auth_bloc.dart';
import 'package:http_request/utils/showAlert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  String email;
  String password;
  String message;

  // LoginScreen({this.email, this.password, this.message});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isValid = false;
  String _email;
  String _password;
  bool _showPassword = true;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  var emailEditingController = TextEditingController();
  var passEditingController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName + " email: " + user.email);

    setState(() {
      //_message = "You are signed in";
    });

    var params = Map<String, dynamic>();
    params["access_token"] = googleAuth.accessToken;

    return user;
  }

  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = new AuthBloc();
  }

  void _checkEmailPassword() {
    setState(() {
      _isValid = _isEmailValid && _isPasswordValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Đăng nhập')),
      ),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Container(
          child: Column(
        children: <Widget>[
          _txtTitleEmail(),
          _inputEmail(),
          _txtTitlePassword(),
          _inputPassword(),
          _btnLogin(),
          _forgotPassword(),
          _socialLogin(),
          _registerAccount(context),
        ],
      )),
    ));
  }

  Widget _txtTitleEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text('EMAIL'),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          )),
    );
  }

  Widget _inputEmail() {
    return StreamBuilder<String>(
        stream: _authBloc.emailStream,
        builder: (context, snapshot) {
          return Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: TextFormField(
                controller: emailEditingController,
                decoration: InputDecoration(
                    errorText: snapshot.hasError ? snapshot.error : null,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    labelText: 'Nhập email',
                    hintText: 'abc@xyz.com'),
                onChanged: (text) {
                  _email = text;
                  _isEmailValid = !_email.isEmpty;
                  _checkEmailPassword();
                },
                keyboardType: TextInputType.text,
              ));
        });
  }

  Widget _txtTitlePassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text("MẬT KHẨU"),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          )),
    );
  }

  Widget _inputPassword() {
    return StreamBuilder<String>(
      stream: _authBloc.passwordStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: TextFormField(
            controller: passEditingController,
            decoration: InputDecoration(
              errorText: snapshot.hasError ? snapshot.error : null,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
              labelText: 'Nhập mật khẩu',
              hintText: '',
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
              _password = text;
              _isPasswordValid = !_password.isEmpty;
              _checkEmailPassword();
            },
            obscureText: _showPassword,
            keyboardType: TextInputType.text,
          ),
        );
      },
    );
  }

  Widget _btnLogin() {
    return GestureDetector(
      onTap: () {
        _onLoginClick();
      },
      child: Container(
          margin: EdgeInsets.all(10),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: _isValid ? Colors.orangeAccent : Colors.grey),
          child: Center(child: Text('Đăng nhập'))),
    );
  }

  void _onLoginClick() {
    if (_authBloc.isValid(
        emailEditingController.text, passEditingController.text)) {
      var params = Map<String, dynamic>();
      params["email"] = emailEditingController.value.text;
      params["password"] = passEditingController.value.text;

      _authBloc.signInAction(params: params).then((data) {
        // print(data);
        if (data.code != 200) {
          return showAlert(context, "Error", data.message);
        } else {
          _goMainScreen();
          // Navigator.pop(context);
        }
      });
    }
  }

  void _goMainScreen() {
    Navigator.pushNamed(context, "/mainScreen");
  }

  void _goToUser() {
    Navigator.pushNamed(context, "/user");
  }

  Widget _forgotPassword() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
            alignment: Alignment.centerRight, child: Text('Quên mật khẩu?')));
  }

  Widget _socialLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
          child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                  // alignment: Alignment.center,
                  child: Center(child: Text('Đăng nhập nhanh với:')))),
          Container(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // object alignment in Row
              children: [_fbLogin(), _ggLogin()],
            ),
          )
        ],
      )),
    );
  }

  Widget _fbLogin() {
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

  Widget _ggLogin() {
    return GestureDetector(
      onTap: () {
        print('gg login');
        _handleGoogleSignIn().then((result) => {});
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

  Widget _registerAccount(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/register")
                      .then((result) => print(result));
                },
                child: Text('Bạn chưa có tài khoản? Đăng ký'))));
  }
}
