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
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text(
          'Đăng kí',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Replace with your hotel-themed background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Tên đăng nhập",
              labelText: "Nhập tên đăng nhập",
              value: "",
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Họ tên",
              labelText: "Nhập họ tên",
              value: "",
              onChanged: (value) {
                setState(() {
                  _fullname = value;
                });
              },
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Email",
              labelText: "Nhập email",
              value: "",
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Mật khẩu",
              labelText: "Nhập mật khẩu",
              value: "",
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Số điện thoại",
              labelText: "Nhập số điện thoại",
              value: "",
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Xử lý đăng kí
                  User user = User(
                      999, "", _password, _fullname, _email, _phoneNumber, 1);
                  print('Đăng kí với thông tin $user');
                  if (await doRegister(
                      _username, _password, _fullname, _email, _phoneNumber, "0")) {
                    final snackBar = SnackBar(
                      content: Text('Đăng kí thành công !'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(userLogin: _user),
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Đăng kí thất bại ! Kiểm tra lại thông tin.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'Đăng kí',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                  ),

                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(300, 50)), // Set minimum size
                  backgroundColor: MaterialStateProperty.all(Colors.green), // Background color
                  elevation: MaterialStateProperty.all(5), // Elevation
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Button border radius
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding
                  ),
                ),
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
              child: Text(
                'Đăng nhập',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> doRegister(String username, String password, String fullname,
      String email, String phoneNumber, String userType) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.143:8080/api/user/register'),
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
