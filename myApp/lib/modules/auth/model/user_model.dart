import 'package:shared_preferences/shared_preferences.dart';

class SignInResponse {
  int code;
  UserInfo data;
  String message;

  SignInResponse({
    this.code,
    this.data,
    this.message,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        code: json["code"],
        data: !json.containsKey("data")
            ? UserInfo()
            : UserInfo.fromJson(json["data"]),
        message: json["message"],
      );
}

class UserInfo {
  int userId;
  String name;
  String email;
  String address;
  String address1;
  String phone;
  String avatar;
  int roleId;
  int groupId;

  UserInfo({
    this.userId,
    this.name,
    this.email,
    this.address,
    this.address1,
    this.phone,
    this.avatar,
    this.roleId,
    this.groupId,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json["customer_id"] == null ? 0 : json["customer_id"],
      name: json["name"] == null ? "" : json["name"],
      email: json["email"] == null ? "" : json["email"],
      address: json["address"] == null ? "" : json["address"],
      address1: json["address1"] == null ? "" : json["address_1"],
      phone: json["phone"] == null ? "" : json["phone"],
      avatar: json["avatar_url"] == null ? "" : json["avatar_url"],
      roleId: json["role_id"] == null ? 0 : json["role_id"],
      groupId: json["group_id"] == null ? 0 : json["group_id"],
    );
  }
}

Future setSharedUserData(UserInfo user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_name', user.name);
  await prefs.setString('user_email', user.email);
  await prefs.setString('user_avatar', user.avatar);
  await prefs.setString('user_phone', user.phone);
  await prefs.setString('user_address', user.address);
  await prefs.setString('user_address1', user.address1);
}
