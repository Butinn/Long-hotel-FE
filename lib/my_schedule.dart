import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/ScheduleDetailsScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';

class MySchedulePage extends StatefulWidget {
  final User userLogin;

  MySchedulePage({required this.userLogin});

  @override
  _MySchedulePagePageState createState() =>
      _MySchedulePagePageState(user: userLogin);
}

class _MySchedulePagePageState extends State<MySchedulePage> {
  List<Schedule> _schedules = [];
  String _searchText = '';
  final User user;
  final String backgroundImage = 'background.PNG';

  _MySchedulePagePageState({required this.user});

  @override
  void initState() {
    super.initState();
    _getSchedules();
  }

  void _getSchedules() async {
    int userId = user.id;
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/schedule/my-schedule?userId=$userId'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      _schedules = (jsonData as List)
          .map((schedule) => Schedule.fromJson(schedule))
          .toList();
    });
  }

  List<Schedule> get filteredSchedules {
    if (_searchText.isEmpty) {
      return _schedules;
    } else {
      return _schedules
          .where((schedule) =>
              schedule.fullname.contains(_searchText) ||
              schedule.phoneNumber.contains(_searchText))
          .toList();
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Danh sách lượt khám của tôi'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: _schedules.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text(_schedules[index].phoneNumber),
  //           subtitle: Text(_schedules[index].note),
  //           trailing: Icon(Icons.arrow_forward),
  //           onTap: () {
  //             // Điều hướng đến trang chi tiết lịch
  //
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) =>
  //                     ScheduleDetailsScreen(schedule: _schedules[index]),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phòng đặt của tôi'),
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
      body: Container(
        color: Color(0x80FFFFFF).withOpacity(0.5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tên',
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
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filteredSchedules[index].fullname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Ngày hẹn: " +
                        filteredSchedules[index].appointmentTime),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleDetailsScreen(
                            schedule: filteredSchedules[index],
                            userLogin: user,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          filteredSchedules[index].status == 1
                              ? 'Đã xác nhận'
                              : 'Chưa xác nhận',
                          style: TextStyle(
                            color: filteredSchedules[index].status == 1
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
