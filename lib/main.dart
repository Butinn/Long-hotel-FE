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
  final String backgroundImage = 'assets/background.jpg';

  late String _username;
  late String _password = "";
  late User _user;
  late User _userResponse = User.empty();
  late String _url = "10.145.12.230";
  bool _hidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void _handleLogin() {
    // Perform login logic here
    print('Logging in with username $_username and password $_password');
    // Replace with your login function
    doLogin(_username, _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Đăng nhập',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white
            )
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    'assets/longicon.png',
                    width: 250,
                    height: 200,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập',
                      hintText: 'Nhập tên đăng nhập',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to signup page
                    print('Chuyển đến trang đăng kí');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Đăng kí tài khoản',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogin(String username, String password) async {
    const url = 'http://192.168.0.143:8080/api/user/login';
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
