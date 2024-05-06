import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/InputText.dart';
import 'package:my_app/home.dart';
import 'package:my_app/main.dart';
import 'package:my_app/model/user.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late String _username;
  late String _fullname;
  late String _email;
  late String _password;
  late String _phoneNumber;
  late User _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng kí'),
      ),
      body: Column(
        children: [
          InputText(
              errorText: "",
              hintText: "Tên đăng nhập",
              labelText: "Nhập tên đăng nhập",
              value: "",
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              }),
          InputText(
              errorText: "",
              hintText: "Họ tên",
              labelText: "Nhập họ tên",
              value: "",
              onChanged: (value) {
                setState(() {
                  _fullname = value;
                });
              }),
          InputText(
              errorText: "",
              hintText: "Email",
              labelText: "Nhập email",
              value: "",
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              }),
          InputText(
              errorText: "",
              hintText: "Mật khẩu",
              labelText: "Nhập mật khẩu",
              value: "",
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              }),
          InputText(
              errorText: "",
              hintText: "Số điện thoại",
              labelText: "Nhập số điện thoại",
              value: "",
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bo góc của button
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size.fromHeight(50), // Chiều cao của button
                ),
              ),
              onPressed: () async {
                // Xử lý đăng kí
                User user = User(
                    999, "", _password, _fullname, _email, _phoneNumber, 1);
                print('Đăng kí với thông tin $user');
                if (await doRegister(_username, _password, _fullname, _email,
                    _phoneNumber, "0")) {
                  final snackBar = SnackBar(
                    content: Text('Đăng kí thành công !'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(userLogin: _user)),
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text('Đăng kí thất bại ! Kiểm tra lại thông tin.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Đăng kí'),
            ),
          ),
          TextButton(
            onPressed: () {
              // Chuyển đến trang đăng nhập
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  Future<bool> doRegister(String username, String password, String fullname,
      String email, String phoneNumber, String userType) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'fullname': fullname,
        'email': email,
        'phoneNumber': phoneNumber,
        'userType': userType
      }),
    );
    print('${response.statusCode}');
    final userData = jsonDecode(response.body);
    _user = User.fromJson(userData);
    return (response.statusCode == 200);
  }
}
