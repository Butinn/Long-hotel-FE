import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/ScheduleDetailsScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';

class ScheduleListPage extends StatefulWidget {
  final User userLogin;

  ScheduleListPage({required this.userLogin});

  @override
  _ScheduleListPageState createState() =>
      _ScheduleListPageState(user: userLogin);
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<Schedule> _schedules = [];
  String _searchText = '';
  final User user;
  final String backgroundImage = 'clinic.jpg';

  _ScheduleListPageState({required this.user});

  @override
  void initState() {
    super.initState();
    _getSchedules();
  }

  void _getSchedules() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/schedule/ds-lich-kham'));
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
              schedule.phoneNumber.contains(_searchText) ||
              schedule.fullname.contains(_searchText))
          .toList();
    }
  }

  Future<void> confirmSchedule(String scheduleId) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api/schedule/xac-nhan-lich-kham/$scheduleId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': scheduleId,
      }),
    );
    print('${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phòng'),
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
                hintText: 'Tìm kiếm theo tên hoặc số điện thoại',
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
                bool isConfirmed = filteredSchedules[index].status ==
                    1; // Giả sử có thuộc tính isConfirmed cho mỗi phần tử
                return ListTile(
                  title: Text(
                    filteredSchedules[index].fullname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                      "Ngày hẹn: " + filteredSchedules[index].appointmentTime +" "),
                  onTap: () {
                    // Điều hướng đến trang chi tiết lịch

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
                      SizedBox(width: 10),
                      // Khoảng cách giữa nhãn và nút xác nhận
                      GestureDetector(
                        onTap: () {
                          // Xử lý sự kiện khi biểu tượng được nhấn
                          // Ví dụ: Đánh dấu lịch là đã xác nhận
                          setState(() {
                            filteredSchedules[index].status = 1;
                            confirmSchedule(
                                filteredSchedules[index].id.toString());
                          });
                        },
                        child: Icon(
                          isConfirmed
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: isConfirmed ? Colors.green : Colors.grey,
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
    );
  }
}
