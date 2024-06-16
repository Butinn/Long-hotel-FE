import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/UserDetailsScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/user.dart';

class UserListPage extends StatefulWidget {
  final User userLogin;

  UserListPage({required this.userLogin});

  @override
  _UserListPageState createState() => _UserListPageState(user: userLogin);
}

class _UserListPageState extends State<UserListPage> {
  final User user;
  final String backgroundImage = 'background.PNG';

  _UserListPageState({required this.user});

  List<User> _users = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/user/get-all-user'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      _users = (jsonData as List).map((user) => User.fromJson(user)).toList();
    });
  }

  List<User> get filteredUsers {
    if (_searchText.isEmpty) {
      return _users;
    } else {
      return _users
          .where((user) =>
              user.fullname.contains(_searchText) ||
              user.phone_number.contains(_searchText))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Danh sách người dùng',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white
            )
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(userLogin: user)),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo số điện thoại hoặc tên',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final tenDayDu = filteredUsers[index].fullname.toUpperCase();

                final avatarLetter = tenDayDu
                    .substring(tenDayDu.lastIndexOf(" ") + 1, tenDayDu.length)
                    .toUpperCase();
                return ListTile(
                  leading: Container(
                    width: 68,
                    height: 68,
                    child: CircleAvatar(
                      child: Text(avatarLetter),
                    ),
                  ),
                  title: Text(filteredUsers[index].fullname),
                  subtitle: Text(filteredUsers[index].email),
                  onTap: () {
                    // Điều hướng đến trang chi tiết người dùng

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                          user: filteredUsers[index],
                          userLogin: widget.userLogin,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
