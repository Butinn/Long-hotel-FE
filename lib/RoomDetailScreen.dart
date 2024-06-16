import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/ReserveRoom.dart';
import 'package:my_app/RoomEditScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/appointment.dart';
import 'package:my_app/model/user.dart';

import 'model/room.dart';

class RoomDetailScreen extends StatelessWidget {
  final Room room;
  final User userLogin;
  final String backgroundImage = 'assets/background.jpg';

  late Appointment _appointment;
  RoomDetailScreen({required this.room, required this.userLogin});

  @override
  Widget build(BuildContext context) {
    _getAppointment();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Chi tiết phòng',
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
                builder: (context) => MyHomePage(userLogin: userLogin),
              ),
            );
          },
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover, // Cover ensures the image covers the entire container
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Thông tin chi tiết phòng',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          room.room_type == 1
                              ? 'assets/singlebed.jpg'
                              : 'assets/doublebed.png',
                          width: 400, // Adjust width as needed
                          height: 200, // Adjust height as needed
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          'ID phòng: ${room.id}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Số phòng: ${room.room_number}',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          room.status == 0
                              ? 'Trạng thái: Còn trống'
                              : 'Trạng thái: Đã đặt',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          room.room_type == 1
                              ? 'Loại phòng: Giường đơn'
                              : 'Loại phòng: Giường đôi',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Tiện ích: ${room.feature}',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Mô tả: ${room.description}',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (userLogin.userType == 1)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomEditScreen(
                                roomDetail: room,
                                userLogin: userLogin,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white38,
                        ),
                        child: Text(
                          'Sửa thông tin',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
                      ),
                    if (userLogin.userType == 1)
                      ElevatedButton(
                        onPressed: () {
                          _deleteRoom(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                          child: Text(
                            'Xóa phòng',
                            style: TextStyle(
                              color: Colors.black, // Text color
                            ),
                          ),
                      ),
                    if (room.status == 0)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReserveRoom(
                                user: userLogin,
                                room: room,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent,
                        ),
                        child: Text(
                          'Đặt phòng',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
                      ),
                    if (userLogin.userType == 1 && room.status == 1)
                      ElevatedButton(
                        onPressed: () async {
                          if (await doUpdateRoomStatus(room.id)) {
                            doUpdateAppointmentStatus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Trả phòng thành công!'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  userLogin: userLogin,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('Trả phòng thất bại! Vui lòng thử lại.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text(
                          'Trả phòng',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteRoom(BuildContext context) async {
    // Hiển thị hộp thoại xác nhận
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa phòng'),
          content: Text('Bạn có chắc chắn muốn xóa phòng này?'),
          actions: [
            TextButton(
              onPressed: () {
                // Đóng hộp thoại
                Navigator.of(context).pop(false);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Đóng hộp thoại và trả về giá trị đúng
                Navigator.of(context).pop(true);
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận xóa, gửi yêu cầu xóa đến server
    if (confirm) {
      // Gửi yêu cầu xóa người dùng đến server ở đây
      // ...
      deleteRoom(room.id, context);
      print('xóa room');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(userLogin: userLogin)),
      );
      // final snackBar = SnackBar(
      //   content: Text('Xóa thành công !'),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print('không xóa room nữa');
    }
  }

  Future<bool> doUpdateRoomStatus(int id) async {
    final response = await http.put(
      Uri.parse('http://192.168.0.143:8080/api/room/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'id': id, 'status': 0}),
    );
    return (response.statusCode == 200);
  }

  void _getAppointment() async {
    int roomId = room.id;
    final response = await http.get(Uri.parse(
        'http://192.168.0.143:8080/api/appointment/get-appointment-by-roomId-and-status/$roomId/0'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    _appointment = Appointment.fromJson(jsonData);
  }

  Future<bool> doUpdateAppointmentStatus() async {
    int appointmentId = _appointment.id;
    final response = await http.put(
      Uri.parse('http://192.168.0.143:8080/api/appointment/edit/$appointmentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: jsonEncode(<String, dynamic>{'id': id, 'status': 0}),
    );
    return (response.statusCode == 200);
  }

  Future<void> deleteRoom(int roomId, BuildContext context) async {
    final url = 'http://192.168.0.143:8080/api/room/delete/$roomId';

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      // Nếu kết quả trả về thành công
      final snackBar = SnackBar(
        content: Text('Xóa thành công !'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Nếu kết quả trả về không thành công
      final snackBar = SnackBar(
        content: Text('lỗi !'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
