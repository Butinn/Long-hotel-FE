import 'package:flutter/material.dart';
import 'package:my_app/RoomCreate.dart';
import 'package:my_app/UserDetailsScreen.dart';
import 'package:my_app/createSchedule.dart';
import 'package:my_app/list_schedule.dart';
import 'package:my_app/list_user.dart';
import 'package:my_app/main.dart';
import 'package:my_app/my_schedule.dart';

import 'model/user.dart';

class MyHomePage extends StatelessWidget {
  final User userLogin;
  final String backgroundImage = 'assets/background.jpg';

  MyHomePage({required this.userLogin});

  @override
  Widget build(BuildContext context) {
    String fullname = userLogin.fullname;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Trang chủ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white
            )
        ),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: userLogin.userType == 1,
                // true: hiển thị widget, false: ẩn widget
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Image.asset(
                      'assets/longicon.png', // Provide your image path here
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                    ),
                    SizedBox(height: 80),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ nhất
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserListPage(userLogin: userLogin),
                          ),
                        );
                      },
                      child: Text(
                        'Quản lý người dùng',
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
                      child: Text(
                        'Quản lý phòng',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 18, // Font size
                          fontWeight: FontWeight.bold, // Font weight
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(300, 50)), // Set minimum size
                        backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent), // Background color
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút bấm thứ hai
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomCreate(
                              userLogin: userLogin,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Thêm phòng',
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
                  ],
                ),
              ),
              Visibility(
                visible: userLogin.userType == 0,
                // true: hiển thị widget, false: ẩn widget
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Image.asset(
                      'assets/longicon.png', // Provide your image path here
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                    ),
                    SizedBox(height: 80),
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
                      child: Text(
                        'Xem thông tin cá nhân',
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
                      child: Text(
                        'Đặt phòng',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 18, // Font size
                          fontWeight: FontWeight.bold, // Font weight
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(300, 50)), // Set minimum size
                        backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent), // Background color
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
                      child: Text(
                        'Kiểm tra đặt phòng',
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
