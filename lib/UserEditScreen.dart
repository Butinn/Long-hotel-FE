import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/InputText.dart';
import 'package:my_app/UserDetailsScreen.dart';
import 'package:my_app/model/user.dart';

class UserEditScreen extends StatefulWidget {
  final User userDetail;
  final User userLogin;

  UserEditScreen({required this.userDetail, required this.userLogin});

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _password;
  late String _fullname;
  late String _username;
  late String _phoneNumber;
  late String _email;

  @override
  void initState() {
    super.initState();
    _id = widget.userDetail.id.toString();
    _fullname = widget.userDetail.fullname;
    _phoneNumber = widget.userDetail.phone_number;
    _email = widget.userDetail.email;
    _username = widget.userDetail.username;
    _password = widget.userDetail.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin người dùng'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            InputText(
                errorText: "",
                hintText: "",
                labelText: "Tên đăng nhập",
                value: _username,
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Mật khẩu",
                value: _password,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Họ tên",
                value: _fullname,
                onChanged: (value) {
                  setState(() {
                    _fullname = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Số điện thoại",
                value: _phoneNumber,
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Email",
                value: _email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Gửi request POST đến API để cập nhật thông tin người dùng
            final url = 'http://localhost:8080/api/user/edit';
            final headers = {'Content-Type': 'application/json'};
            final body = jsonEncode({
              'id': widget.userDetail.id,
              'fullname': _fullname,
              'phoneNumber': _phoneNumber,
              'email': _email,
              'username': _username,
              'password': _password,
            });
            User user = User(widget.userDetail.id, _username, _password,
                _fullname, _email, _phoneNumber, widget.userDetail.userType);
            final response =
                await http.put(Uri.parse(url), headers: headers, body: body);
            if (response.statusCode == 200) {
              // Cập nhật thành công
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(
                    user: user,
                    userLogin: widget.userLogin,
                  ),
                ),
              );
            } else {
              // Xảy ra lỗi khi cập nhật
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Lỗi'),
                    content: Text('Không thể cập nhật thông tin người dùng'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
