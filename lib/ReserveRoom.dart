import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:my_app/CustomDropDown.dart';
import 'package:my_app/InputText.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/appointment.dart';
import 'package:my_app/model/room.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/primaryThemeColor.dart';

class ReserveRoom extends StatefulWidget {
  final User user;
  final Room room;

  ReserveRoom({required this.user, required this.room});

  @override
  _ReserveRoomPageState createState() =>
      _ReserveRoomPageState(user: user, room: room);
}

class _ReserveRoomPageState extends State<ReserveRoom> {
  final User user;
  final Room room;

  late Room _room;
  late Appointment _appointment;

  late int _id;
  late int _userId = user.id;
  late int _roomId = room.id;
  late String _roomNumber = room.room_number;
  late String _fullname = "";
  late String _phoneNumber = "";
  late String _note = "";
  late double _totalPrice = room.price;

  late String _appointmentTime = "";
  late String _createdAt;
  late int _status;
  late int _timeSlot;
  late String _selectedTimeSlot = '';

  List<int> listTimeSlot = [1];

  List<Room> listRoom = [];

  // var formatDate = intl.DateFormat('dd/MM/yyyy');
  var formatDate = intl.DateFormat('yyyy-MM-dd');

  _ReserveRoomPageState({required this.user, required this.room});

  @override
  void initState() {
    super.initState();
    getListRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Đặt phòng khách sạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(userLogin: user),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputText(
                errorText: "",
                hintText: "Nhập họ và tên",
                labelText: "Họ và tên",
                value: "",
                onChanged: (value) {
                  setState(() {
                    _fullname = value;
                  });
                },
              ),
              SizedBox(height: 20),
              InputText(
                errorText: "",
                hintText: "Số điện thoại liên hệ",
                labelText: "Nhập số điện thoại liên hệ",
                value: "",
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
              ),
              SizedBox(height: 20),
              InputText(
                isEnable: false,
                errorText: "",
                hintText: _roomNumber,
                labelText: "Số phòng",
                value: "",
                onChanged: (value) {
                  setState(() {
                    _roomNumber = value;
                  });
                },
              ),
              SizedBox(height: 20),
              InputText(
                isEnable: false,
                errorText: "",
                hintText: _totalPrice.toString() + 'VND/ 1 Ngày',
                labelText: "Giá phòng",
                value: "",
                onChanged: (value) {
                  setState(() {
                    _totalPrice = double.parse(value);
                  });
                },
              ),
              SizedBox(height: 20),
              InputText(
                errorText: "",
                hintText: "Ghi chú",
                labelText: "Nhập ghi chú",
                value: "",
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_fullname == "") {
                      final snackBar = SnackBar(
                        content: Text('Tên không được để trống'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (_phoneNumber == "") {
                      final snackBar = SnackBar(
                        content: Text('Số điện thoại không được để trống'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (await doUpdateRoomStatus(room.id)) {
                      doCreateAppointment(
                        _userId,
                        _roomId,
                        _fullname,
                        _phoneNumber,
                        _totalPrice,
                        _note,
                      );
                      final snackBar = SnackBar(
                        content: Text('Đặt phòng thành công !'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(userLogin: user),
                        ),
                      );
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Đặt phòng thất bại ! Kiểm tra lại thông tin.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    'Đặt phòng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    elevation: MaterialStateProperty.all(5),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> doCreateAppointment(int userId, int roomId, String fullname,
      String phoneNumber, double totalPrice, String note) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.143:8080/api/appointment/create-appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId.toString(),
        'roomId': roomId.toString(),
        'fullname': fullname,
        'phoneNumber': phoneNumber,
        'totalPrice': totalPrice.toString(),
        'roomNumber': room.room_number,
        'note': note
      }),
    );
    print('${response.statusCode}');
    final appointmentData = jsonDecode(response.body);
    _appointment = Appointment.fromJson(appointmentData);
    return (response.statusCode == 200);
  }

  Future<bool> doUpdateRoomStatus(int id) async {
    final response = await http.put(
      Uri.parse('http://192.168.0.143:8080/api/room/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'id': id, 'status': 1}),
    );
    return (response.statusCode == 200);
  }

  void getListRoom() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/room/get-all-room'));
    //final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> jsonList = json.decode(response.body);
    final List<Room> roomList =
        jsonList.map((json) => Room.fromJson(json)).toList();
    setState(() {
      listRoom = roomList;
      print(roomList);
    });
  }
}
