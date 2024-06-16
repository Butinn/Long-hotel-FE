import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/RoomDetailScreen.dart';
import 'package:my_app/ScheduleDetailsScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';

import 'model/room.dart';

class ScheduleListPage extends StatefulWidget {
  final User userLogin;

  ScheduleListPage({required this.userLogin});

  @override
  _ScheduleListPageState createState() =>
      _ScheduleListPageState(user: userLogin);
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<Room> _roomList = [];
  String _searchText = '';
  final User user;
  final String backgroundImage = 'assets/longhotel.jpg';

  _ScheduleListPageState({required this.user});

  @override
  void initState() {
    super.initState();
    _getListRoom();
  }

  void _getListRoom() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/room/get-all-room'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      _roomList = (jsonData as List)
          .map((schedule) => Room.fromJson(schedule))
          .toList();
    });
  }

  List<Room> get filteredRoom {
    if (_searchText.isEmpty) {
      if (user.userType == 0) {
        return _roomList
            .where((room) => room.status == 0)
            .toList();
      } else {
        return _roomList;
      }
    } else {
      return _roomList
          .where((room) => room.room_number.contains(_searchText))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Danh sách phòng',
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
            child: ListView.builder(
              itemCount: filteredRoom.length,
              itemBuilder: (context, index) {
                bool isConfirmed = filteredRoom[index].status == 1; // Giả sử có thuộc tính isConfirmed cho mỗi phần tử
                return ListTile(
                  leading: Container(
                    width: 68,
                    height: 68,
                    child: CircleAvatar(
                      child: Icon(Icons.house),
                    ),
                  ),
                  title: Text(
                    "Phòng " + filteredRoom[index].room_number,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                      "Giá " + filteredRoom[index].price.toString() +" VND/ 1 Ngày"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(
                          room: filteredRoom[index],
                          userLogin: user,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filteredRoom[index].status == 1
                            ? 'Đã đặt'
                            : 'Còn trống',
                        style: TextStyle(
                          color: filteredRoom[index].status == 1
                              ? Colors.red
                              : Colors.green,
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
    );
  }
}
