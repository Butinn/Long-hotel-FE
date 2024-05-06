import 'package:flutter/material.dart';
import 'package:my_app/UserDetailsScreen.dart';
import 'package:my_app/createSchedule.dart';
import 'package:my_app/list_schedule.dart';
import 'package:my_app/list_user.dart';
import 'package:my_app/main.dart';
import 'package:my_app/my_schedule.dart';

import 'model/user.dart';

class MyHomePage extends StatelessWidget {
  final User userLogin;
  final String backgroundImage = 'clinic.jpg';

  MyHomePage({required this.userLogin});

  @override
  Widget build(BuildContext context) {
    String fullname = userLogin.fullname;
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Thực hiện đăng xuất tại đây
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text(
      //           'Menu',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           // Xử lý sự kiện khi nhấn vào mục Home
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Settings'),
      //         onTap: () {
      //           // Xử lý sự kiện khi nhấn vào mục Settings
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.info),
      //         title: Text('About'),
      //         onTap: () {
      //           // Xử lý sự kiện khi nhấn vào mục About
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: userLogin.userType == 1,
                // true: hiển thị widget, false: ẩn widget
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ nhất
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserListPage(userLogin: userLogin)),
                        );
                      },
                      child: Text('Quản lý người dùng'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(30, 30, 30,
                            30), // Increase padding to increase button size
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ hai
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduleListPage(
                                    userLogin: userLogin,
                                  )),
                        );
                      },
                      child: Text('Quản lý lịch khám'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 30, 35,
                            30), // Increase padding to increase button size
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: userLogin.userType == 0,
                // true: hiển thị widget, false: ẩn widget
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ nhất
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(
                              user: userLogin,
                              userLogin: userLogin,
                            ),
                          ),
                        );
                      },
                      child: Text('Xem thông tin cá nhân'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(30, 30, 30,
                            30), // Increase padding to increase button size
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ hai
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateSchedule(user: userLogin)),
                        );
                      },
                      child: Text('Tạo lịch khám'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(55, 30, 55,
                            30), // Increase padding to increase button size
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ hai
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MySchedulePage(userLogin: userLogin)),
                        );
                      },
                      child: Text('Lịch khám của tôi'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(43, 30, 43,
                            30), // Increase padding to increase button size
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
