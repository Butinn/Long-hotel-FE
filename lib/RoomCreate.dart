import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/InputText.dart';
import 'package:my_app/home.dart';
import 'package:my_app/main.dart';
import 'package:my_app/model/room.dart';
import 'package:my_app/model/user.dart';

import 'CustomDropDown.dart';
import 'model/appointment.dart';

class RoomCreate extends StatefulWidget {
  final User userLogin;
  RoomCreate({required this.userLogin});

  @override
  _RoomCreatePage createState() => _RoomCreatePage(user: userLogin);
}

class _RoomCreatePage extends State<RoomCreate> {
  late Room _room;

  late String _roomNumber;
  late int _roomType;
  late double _price;
  late String _note;
  late String _feature;
  late String _description;
  final User user;

  late String _selectedRoom = "---Chọn loại phòng---";

  _RoomCreatePage({required this.user});

  // Define a list of room types
  List<String> _listRoomType = [
    'Giường đơn',
    'Giường đôi'
  ]; // Update with your room types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text(
          'Tạo phòng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Replace with your hotel-themed background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Số phòng",
              labelText: "Nhập số phòng",
              value: "",
              onChanged: (value) {
                setState(() {
                  _roomNumber = value;
                });
              },
            ),
            SizedBox(height: 20),
            Visibility(
              visible: true,
              child: GestureDetector(
                onTap: () => {
                  showListRoomType()
                },
                child: InputText(
                  isEnable: false,
                  errorText: "",
                  hintText: _selectedRoom,
                  labelText: "Chọn loại phòng",
                  value: "",
                  onChanged: (newValue){
                    setState(() {
                      _selectedRoom = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Giá phòng",
              labelText: "Nhập giá phòng",
              onChanged: (value) {
                setState(() {
                  _price = double.tryParse(value) ?? 0; // Convert value to int
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
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Tiện ích",
              labelText: "Nhập tiện ích",
              value: "",
              onChanged: (value) {
                setState(() {
                  _feature = value;
                });
              },
            ),
            SizedBox(height: 20),
            InputText(
              errorText: "",
              hintText: "Mô tả",
              labelText: "Nhập mô tả",
              value: "",
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Xử lý tạo phòng
                  Room room = Room(
                      999, _roomNumber, 0, _roomType, _price, _note, _feature, _description);
                  print('Tạo phòng với thông tin $room');
                  if (await doAddRoom(_roomNumber, _roomType, _price, _note)) {
                    final snackBar = SnackBar(
                      content: Text('Tạo phòng thành công !'),
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
                      content: Text('Tạo phòng thất bại ! Kiểm tra lại thông tin.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'Tạo phòng',
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
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> doAddRoom(String roomNumber, int roomType,
      double price, String note) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.143:8080/api/room/add-room'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'roomNumber': roomNumber,
        'roomType': roomType.toString(),
        'price': price.toString(),
        'note': note,
      }),
    );
    print('${response.statusCode}');
    final roomData = jsonDecode(response.body);
    _room = Room.fromJson(roomData);
    return (response.statusCode == 200);
  }

  void showListRoomType() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Chọn loại phòng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _listRoomType.length,
                  itemBuilder: (context, index) {
                    return  ListTile(
                      title: Text('${_listRoomType[index]} '),
                      onTap: () {
                        setState(() {
                          _selectedRoom = _listRoomType[index];
                          _roomType = index+1;
                        });
                        Navigator.pop(context);
                        print(_selectedRoom);
                      },
                      enabled: true,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
