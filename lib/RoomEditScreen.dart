import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/InputText.dart';
import 'package:my_app/RoomDetailScreen.dart';
import 'package:my_app/UserDetailsScreen.dart';
import 'package:my_app/model/room.dart';
import 'package:my_app/model/user.dart';

class RoomEditScreen extends StatefulWidget {
  final Room roomDetail;
  final User userLogin;

  RoomEditScreen({required this.roomDetail, required this.userLogin});

  @override
  _RoomEditScreenState createState() => _RoomEditScreenState();
}

class _RoomEditScreenState extends State<RoomEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _roomNumber;
  late String _selectedRoom;
  late int _roomType;
  late double _price;
  late String _note;
  late String _feature;
  late String _description;

  List<String> _listRoomType = [
    'Giường đơn',
    'Giường đôi'
  ];

  @override
  void initState() {
    super.initState();
    _id = widget.roomDetail.id.toString();
    _roomNumber = widget.roomDetail.room_number;
    _roomType = widget.roomDetail.room_type;
    _selectedRoom = _listRoomType[_roomType - 1];
    _price = widget.roomDetail.price;
    _note = widget.roomDetail.note;
    _feature = widget.roomDetail.feature;
    _description = widget.roomDetail.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin phòng'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            InputText(
                errorText: "",
                hintText: "",
                labelText: "Số phòng",
                value: _roomNumber,
                onChanged: (value) {
                  setState(() {
                    _roomNumber = value;
                  });
                }),
            Visibility(
                visible: true,
                child:GestureDetector(
                  onTap: () => {
                    showListRoomType()
                  },
                  child: InputText(
                    isEnable: false,
                    errorText: "",
                    hintText: _selectedRoom,
                    labelText: "Loại phòng",
                    value: "",
                    onChanged: (newValue){
                      setState(() {
                        _selectedRoom = newValue;
                      });
                    },
                  ),
                )
            ),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Tiện ích",
                value: _feature,
                onChanged: (value) {
                  setState(() {
                    _feature = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Mô tả",
                value: _description,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                }),
            InputText(
              errorText: "",
              hintText: "",
              labelText: "Giá phòng",
              value: _price.toString(),
              onChanged: (value) {
                setState(() {
                  // Parse the input value to double
                  _price = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Ghi chú",
                value: _note,
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Gửi request POST đến API để cập nhật thông tin người dùng
            final url = 'http://192.168.0.143:8080/api/room/edit';
            final headers = {'Content-Type': 'application/json'};
            final body = jsonEncode({
              'id': widget.roomDetail.id,
              'roomNumber': _roomNumber,
              'roomType': _roomType,
              'price': _price,
              'note': _note,
              'feature': _feature,
              'description': _description
            });
            print(body);
            Room room = Room(widget.roomDetail.id, _roomNumber, widget.roomDetail.status,
                _roomType, _price, _note, _feature, _description);
            final response =
            await http.put(Uri.parse(url), headers: headers, body: body);
            if (response.statusCode == 200) {
              // Cập nhật thành công
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomDetailScreen(
                    room: room,
                    userLogin: widget.userLogin,
                  ),
                ),
              );
            } else {
              // Xảy ra lỗi khi cập nhật
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Lỗi'),
                    content: Text('Không thể cập nhật thông tin phòng'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Icon(Icons.save),
      ),
    );
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
