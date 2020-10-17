import 'dart:async';

import 'package:http_request/modules/auth/model/user_model.dart';
import 'package:http_request/modules/auth/service/auth_service.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/utils/validators.dart';

class AuthBloc {
  StreamController _emailController;
  StreamController _passwordController;
  AuthService _authService;

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  AuthBloc() {
    _emailController = StreamController<String>();
    _passwordController = StreamController<String>();
    _authService = new AuthService();
  }

  bool isValid(String email, String pass) {
    bool _isEmailValid = false;
    bool _isPasswordValid = false;

    if (!Validators.isValidEmail(email)) {
      _emailController.sink.addError("Email không hợp lệ");
      return false;
    }
    if (email.length == 0 || email == null) {
      _emailController.sink.addError("Vui lòng nhập email");
      return false;
    }
    _emailController.sink.add("");

    if (!Validators.isValidPass(pass)) {
      _passwordController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    if (pass.length == 0 || pass == null) {
      _passwordController.sink.addError("Vui lòng nhập mật khẩu");
      return false;
    }
    _passwordController.sink.add("");

    return true;
  }

  Future<SignInResponse> signInAction({dynamic params}) {
    Completer<SignInResponse> _c = new Completer();
    var _signInResponse = new SignInResponse();

    if (params == null) {
      _signInResponse.message = "Please input Email and Password";
      _signInResponse.code = 201;
    }

    _authService.signInAction(params: params).then((data) {
      if (data != null) {
        _signInResponse = data;
        if (data.data != null) {
          setSharedUserData(data.data);
        }
      }

      _c.complete(_signInResponse);
    });
    return _c.future;
  }

  Future<void> saveAccessToken(String token) async {
    _authService.saveAccessToken(token);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
