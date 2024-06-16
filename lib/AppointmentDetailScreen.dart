import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/ReserveRoom.dart';
import 'package:my_app/UserEditScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/list_user.dart';
import 'package:my_app/model/appointment.dart';
import 'package:my_app/model/user.dart';

import 'model/appointment.dart';
import 'model/room.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointmentCurrent;
  final User userLogin;
  final Room room;
  final String backgroundImage = 'background.jpg';

  AppointmentDetailScreen({required this.appointmentCurrent, required this.userLogin, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phòng'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(userLogin: userLogin)),
            );
          },
        ),
        backgroundColor: Colors.green, // Setting app bar background color
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage), // Replace with your hotel-themed background image
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            height: 200,
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            'Chủ phòng: ${appointmentCurrent.fullname}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Số điện thoại: ${appointmentCurrent.phone_number}',
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
                            room.room_type == 1
                                ? 'Loại phòng: Giường đơn'
                                : 'Loại phòng: Giường đôi',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Giá phòng: ${appointmentCurrent.total_price} VND/ 1 Ngày',
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
                          SizedBox(height: 10.0),
                          Visibility(
                            visible: true, // Set to true to always show the button
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (await doUpdateRoomStatus(appointmentCurrent.roomId)) {
                                    doUpdateAppointmentStatus();
                                    final snackBar = SnackBar(
                                      content: Text('Hủy phòng thành công !'),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                          userLogin: userLogin,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text('Hủy phòng thất bại! Kiểm tra lại thông tin.'),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: Text(
                                  'Hủy phòng',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 18, // Font size
                                    fontWeight: FontWeight.bold, // Font weight
                                  ),
                                ),
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(Size(100, 50)), // Set minimum size
                                  backgroundColor: MaterialStateProperty.all(Colors.red), // Background color
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
                            ),
                          ),
                        ],
                    ),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );

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

  Future<bool> doUpdateAppointmentStatus() async {
    int appointmentId = appointmentCurrent.id;
    final response = await http.put(
      Uri.parse('http://192.168.0.143:8080/api/appointment/edit/$appointmentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: jsonEncode(<String, dynamic>{'id': id, 'status': 0}),
    );
    return (response.statusCode == 200);
  }
}
