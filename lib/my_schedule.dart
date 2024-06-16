import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/AppointmentDetailScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/appointment.dart';
import 'package:my_app/model/user.dart';
import 'model/room.dart';

class MySchedulePage extends StatefulWidget {
  final User userLogin;

  MySchedulePage({required this.userLogin});

  @override
  _MySchedulePagePageState createState() =>
      _MySchedulePagePageState(user: userLogin);
}

class _MySchedulePagePageState extends State<MySchedulePage> {
  List<Appointment> _appointments = [];
  String _searchText = '';
  final User user;
  List<Room> _roomList = [];
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
        'http://192.168.0.143:8080/api/appointment/get-appointment-by-userid-and-status/$userId/0'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      _appointments = (jsonData as List)
          .map((data) => Appointment.fromJson(data))
          .toList();
    });
  }

  List<Appointment> get filteredSchedules {
    if (_searchText.isEmpty) {
      return _appointments;
    } else {
      return _appointments
          .where((schedule) =>
              schedule.room_number.contains(_searchText))
          .toList();
    }
  }

  Future<bool> _getListRoomSingle(String roomNumber) async {
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/room/get-room/$roomNumber/1'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      _roomList = (jsonData as List)
          .map((schedule) => Room.fromJson(schedule))
          .toList();
    });
    return (response.statusCode == 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Danh sách phòng đặt của tôi',
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
      body: Container(
        color: Color(0x80FFFFFF).withOpacity(0.5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo số phòng',
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
              child: SizedBox(
                height: 500, // Set your desired height
                child: ListView.builder(
                  itemCount: filteredSchedules.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 68,
                        height: 200,
                        child: CircleAvatar(
                          child: Icon(Icons.house),
                        ),
                      ),
                      title: Text(
                        "Phòng " + filteredSchedules[index].room_number,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        if (await _getListRoomSingle(filteredSchedules[index].room_number)){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentDetailScreen(
                                appointmentCurrent: filteredSchedules[index],
                                userLogin: user,
                                room: _roomList[0],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
