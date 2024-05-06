import 'package:flutter/cupertino.dart';

class User {
  int _id;
  String _username;
  String _password;
  String _fullname;
  String _email;
  String _phone_number;
  int _userType;

  User(this._id, this._username, this._password, this._fullname, this._email,
      this._phone_number, this._userType);

  int get userType => _userType;

  set userType(int value) {
    _userType = value;
  }

  String get phone_number => _phone_number;

  set phone_number(String value) {
    _phone_number = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'User{_id: $_id, _username: $_username, _password: $_password, _fullname: $_fullname, _email: $_email, _phone_number: $_phone_number, _userType: $_userType}';
  }
  static User empty() {
    return User(0,"","","","","",0);
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'username': _username,
        'password': _password,
        'fullname': _fullname,
        'email': _email,
        'phoneNumber': _phone_number,
        'userType': _userType
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'] ?? "",
        json['username'] ?? "",
        json['password'] ?? "",
        json['fullname'] ?? "",
        json['email'] ?? "",
        json['phoneNumber'] ?? "",
        json['userType'] ?? "");
  }
}
