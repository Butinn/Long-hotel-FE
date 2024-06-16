import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:my_app/CustomDropDown.dart';
import 'package:my_app/InputText.dart';
import 'package:my_app/home.dart';
import 'package:my_app/model/room.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/primaryThemeColor.dart';

class CreateSchedule extends StatefulWidget {
  final User user;

  CreateSchedule({required this.user});

  @override
  _CreateSchedulePageState createState() =>
      _CreateSchedulePageState(user: user);
}

class _CreateSchedulePageState extends State<CreateSchedule> {
  final User user;
  late int _userId = user.id;
  late int _id;
  late String _fullname = "";
  late String _phoneNumber = user.phone_number;
  late String _note;
  late String _appointmentTime = "";
  late String _createdAt;
  late int _status;
  late int _timeSlot;
  late String _selectedTimeSlot='';
  List<String> timeSlots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '2:00 PM - 4:00 PM',
  ];
  List<int> listTimeSlot=[1];

  List<Room> listRoom = [];

  // var formatDate = intl.DateFormat('dd/MM/yyyy');
  var formatDate = intl.DateFormat('yyyy-MM-dd');

  _CreateSchedulePageState({required this.user});

  @override
  void initState() {
    super.initState();
    getListRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt phòng khách sạn'),
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
          InputText(
              errorText: "",
              hintText: "Nhập họ và tên",
              labelText: "Họ và tên",
              value: "",
              onChanged: (value) {
                setState(() {
                  _fullname = value;
                });
              }),
          InputText(
              errorText: "",
              hintText: "Số điện thoại liên hệ",
              labelText: "Nhập số điện thoại liên hệ",
              value: "",
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              }),

          InputText(
              errorText: "",
              hintText: "Ghi chú",
              labelText: "Nhập ghi chú",
              value: "",
              onChanged: (value) {
                setState(() {
                  _note = value;
                });
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,30,0,0),
            child: ElevatedButton(
              onPressed: () async {
                // Xử lý đăng kí
                Schedule schedule = Schedule(999, _fullname, _userId,
                    _phoneNumber, _note, _appointmentTime, "",1, 0);
                print(_userId);
                print('Đặt phòng với thông tin $schedule');
                if (await doCreateSchedule()) {
                  final snackBar = SnackBar(
                    content: Text('Đặt phòng thành công !'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              userLogin: user,
                            ),
                        fullscreenDialog: true),
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text('Đặt phòng thất bại! Kiểm tra lại thông tin.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Đặt phòng'),
            ),
          ),
        ],
      ),
    );
  }
  void getListTimeSlot(String ngayHen) async {
    print(ngayHen.toString()+"...................");
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/schedule?ngayHen=$ngayHen'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> jsonList = jsonData as List<dynamic>;
    final List<int> numberList = jsonList.map((json) => json as int).toList();
    setState(() {
      listTimeSlot = numberList;
      print(numberList);
    });
  }

  void showTimeSlots(String appointmentTime) {
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
                  'Chọn khung giờ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    String label = listTimeSlot.contains(index+1) ? '(Khung giờ đã có người đặt)' : '';
                    bool isSelectable = !listTimeSlot.contains(index+1);
                    return  ListTile(
                      title: Text('${timeSlots[index]}  $label'),
                      onTap: () {
                        setState(() {
                          _selectedTimeSlot = timeSlots[index];
                          _timeSlot = index+1;
                        });
                        Navigator.pop(context);
                        print(_selectedTimeSlot);
                      },
                      enabled: isSelectable,
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

  void showNgay(String time) {
    FocusScope.of(context).unfocus();
    DateTime dateTime;
    if (time.isEmpty) {
      dateTime = DateTime.now();
    } else {
      dateTime = formatDate.parse(time);
    }
    showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100))
        .then((date) {
      setState(() {
        this._appointmentTime = formatDate.format(date!);
        getListTimeSlot(_appointmentTime);
      });
    });
  }

  Future<bool> doCreateSchedule() async {
    // final queryParameters = {
    //   'userId': _userId,
    //   'phoneNumber': _phoneNumber,
    //   'note': _note,
    //   'appointmentTime': _appointmentTime,
    // };
    // final uri = Uri.https('192.168.0.143:8080', '/api/schedule/dat-lich-kham', queryParameters);
    //
    // final response = await http.post(uri);
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.143:8080/api/schedule/dat-lich-kham?userId=$_userId&fullname=$_fullname&phoneNumber=$_phoneNumber&note=$_note&appointmentTime=$_appointmentTime&timeSlot=$_timeSlot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('${response.statusCode}');
    return (response.statusCode == 200);
  }

  void getListRoom() async {
    print("lmao");
    final response = await http
        .get(Uri.parse('http://192.168.0.143:8080/api/room/get-all-room'));
    //final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> jsonList = json.decode(response.body);
    final List<Room> roomList = jsonList.map((json) => Room.fromJson(json)).toList();
    setState(() {
      listRoom = roomList;
      print(roomList);
    });
  }

  void _showListRoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Phòng'),
          content: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return _buildIcon(Icons.house_outlined); // You can change the icon here
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIcon(IconData iconData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: 40),
        SizedBox(height: 8),
        Text('Icon'),
      ],
    );
  }
}
