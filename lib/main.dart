import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/InputText.dart';
import 'package:my_app/SecurityInputText.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/primaryThemeColor.dart';
import 'package:my_app/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      title: 'Đăng nhập',
      theme: ThemeData(
        primarySwatch: primaryThemeColor,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String backgroundImage = 'HotelBG.jpg';

  late String _username;
  late String _password = "";
  late User _user;
  late User _userResponse = User.empty();
  late String _url = "10.145.12.230";
  bool HidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0, // Độ đổ bóng của AppBar
          title: const Text(
            'Đăng nhập',
            style: TextStyle(
              color: Colors.white, // Màu chữ của tiêu đề
              fontSize: 18, // Kích thước chữ của tiêu đề
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 50),
                child: Image.asset(
                  'assets/hotelicon.png', // Đường dẫn đến tập tin logo
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: InputText(
                    errorText: "",
                    labelText: "Tên đăng nhập",
                    hintText: "Nhập tên đăng nhập",
                    value: "",
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    }),
              ),
              SecurityInputText(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                errorText: 'Không được để trống',
                value: this._password,
                isHidePassword: this.HidePassword,
                onChanged: (value) => setState(() => this._password = value),
                onClickIcon: () =>
                    setState(() => this.HidePassword = !this.HidePassword),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 100), // Độ dài của button
                    ),
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
                    // Xử lý đăng nhập
                    print(
                        'Đăng nhập với tên đăng nhập $_username và mật khẩu $_password');
                    doLogin(_username, _password);
                  },
                  child: Text('Đăng nhập'),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Chuyển đến trang đăng kí
                  print('Chuyển đến trang đăng kí');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text('Đăng kí tài khoản'),
              ),
            ],
          ),
        ));
  }

  Future<void> doLogin(String username, String password) async {
    const url = 'http://localhost:8080/api/user/login';
    final body = json.encode({
      'username': username,
      'password': password,
    });
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      // Nếu kết quả trả về thành công
      final snackBar = SnackBar(
        content: Text('Đăng nhập thành công !'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final userData = jsonDecode(utf8.decode(response.bodyBytes));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyHomePage(userLogin: User.fromJson(userData))),
      );
    } else {
      // Nếu kết quả trả về không thành công
      final snackBar = SnackBar(
        content: Text('Tên đăng nhập hoặc mật khẩu không chính xác !'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
