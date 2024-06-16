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
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text(
          'Cập nhập thông tin người dùng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/background.jpg", // Replace with your image path
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
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
                      },
                    ),
                    SizedBox(height: 20),
                    InputText(
                      errorText: "",
                      hintText: "",
                      labelText: "Mật khẩu",
                      value: _password,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    InputText(
                      errorText: "",
                      hintText: "",
                      labelText: "Họ tên",
                      value: _fullname,
                      onChanged: (value) {
                        setState(() {
                          _fullname = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    InputText(
                      errorText: "",
                      hintText: "",
                      labelText: "Số điện thoại",
                      value: _phoneNumber,
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    InputText(
                      errorText: "",
                      hintText: "",
                      labelText: "Email",
                      value: _email,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 30, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Send a POST request to API to update user information
                            final url = 'http://192.168.0.143:8080/api/user/edit';
                            final headers = {'Content-Type': 'application/json'};
                            final body = jsonEncode({
                              'id': widget.userDetail.id,
                              'fullname': _fullname,
                              'phoneNumber': _phoneNumber,
                              'email': _email,
                              'username': _username,
                              'password': _password,
                            });

                            // Assuming User and UserDetailsScreen classes exist with necessary fields
                            User user = User(
                              widget.userDetail.id,
                              _username,
                              _password,
                              _fullname,
                              _email,
                              _phoneNumber,
                              widget.userDetail.userType,
                            );

                            final response = await http.put(Uri.parse(url), headers: headers, body: body);

                            if (response.statusCode == 200) {
                              // Update successful
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
                              // Update failed
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
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
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Lưu thông tin',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
