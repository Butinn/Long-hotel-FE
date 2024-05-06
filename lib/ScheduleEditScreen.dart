import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:my_app/CustomDropDown.dart';
import 'package:my_app/InputText.dart';
import 'package:my_app/ScheduleDetailsScreen.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';

class ScheduleEditScreen extends StatefulWidget {
  final Schedule scheduleDetail;
  final User userLogin;

  ScheduleEditScreen({required this.scheduleDetail, required this.userLogin});

  @override
  _ScheduleEditScreenState createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _userId;
  late int _timeSlot;
  late String _fullname;
  late String _phoneNumber;
  late String _note;
  late String _appointmentTime;
  late String _createdAt;
  late String _status;
  late String _selectedTimeSlot = '';
  List<String> timeSlots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '2:00 PM - 4:00 PM',
  ];
  List<int> listTimeSlot = [];
  var formatDate = intl.DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _id = widget.scheduleDetail.id.toString();
    _userId = widget.scheduleDetail.userId.toString();
    _fullname = widget.scheduleDetail.fullname;
    _phoneNumber = widget.scheduleDetail.phoneNumber;
    _note = widget.scheduleDetail.note;
    _appointmentTime = widget.scheduleDetail.appointmentTime;
    _createdAt = widget.scheduleDetail.createdAt;
    _status = widget.scheduleDetail.status.toString();
    _timeSlot = widget.scheduleDetail.timeSlot;
    if (_timeSlot != null) {
      _selectedTimeSlot = timeSlots[_timeSlot - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa lịch khám'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Họ và tên",
                value: _fullname,
                onChanged: (value) {
                  setState(() {
                    _fullname = value;
                  });
                }),
            InputText(
                errorText: "",
                hintText: "",
                labelText: "Số điện thoại",
                value: _phoneNumber,
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                }),
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
            CustomDropDown(
              title: 'Thời điểm',
              value: _appointmentTime,
              isError: true,
              errorText: '',
              icon: Icons.date_range_outlined,
              onPress: () {
                showNgay(_appointmentTime);
              },
            ),
            Visibility(
              visible: _appointmentTime != null &&
                  _appointmentTime != "" &&
                  _selectedTimeSlot != null &&
                  _selectedTimeSlot != "",
              child: InputText(
                isEnable: _selectedTimeSlot == null || _selectedTimeSlot == "",
                errorText: "",
                hintText: _selectedTimeSlot,
                labelText: "Khung giờ",
                value: "",
              ),
            ),
            InkWell(
              onTap: () {
                if (_appointmentTime != null && _appointmentTime != "") {
                  showTimeSlots(_appointmentTime);
                } else {
                  // Hiển thị thông báo lỗi nếu chưa chọn ngày
                  print('Vui lòng chọn ngày trước.');
                }
              },
              child: Text(
                'Chọn khung giờ',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Gửi request POST đến API để cập nhật thông tin người dùng
            final url = 'http://localhost:8080/api/schedule/sua-lich-kham';
            final headers = {'Content-Type': 'application/json'};
            final body = jsonEncode({
              'id': widget.scheduleDetail.id,
              'userId': widget.scheduleDetail.userId,
              'fullname': _fullname,
              'phoneNumber': _phoneNumber,
              'note': _note,
              'appointmentTime': _appointmentTime,
              'timeSlot': _timeSlot,
              'createdAt': widget.scheduleDetail.createdAt,
              'status': widget.scheduleDetail.status
            });
            Schedule schedule = Schedule(
                widget.scheduleDetail.id,
                _fullname,
                widget.scheduleDetail.userId,
                _phoneNumber,
                _note,
                _appointmentTime,
                widget.scheduleDetail.createdAt,
                widget.scheduleDetail.timeSlot,
                widget.scheduleDetail.status);
            final response =
                await http.put(Uri.parse(url), headers: headers, body: body);
            if (response.statusCode == 200) {
              // Cập nhật thành công
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleDetailsScreen(
                    schedule: schedule,
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
                    content: Text('Không thể cập nhật lịch khám'),
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

  void getListTimeSlot(String ngayHen) async {
    print(ngayHen.toString() + "...................");
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/schedule?ngayHen=$ngayHen'));
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> jsonList = jsonData as List<dynamic>;
    final List<int> numberList = jsonList.map((json) => json as int).toList();
    setState(() {
      listTimeSlot = numberList;
      print(numberList);
    });
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
        _selectedTimeSlot = '';
      });
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
                padding: const EdgeInsets.fromLTRB(16,16,0,0),
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
                    String label = listTimeSlot.contains(index + 1)
                        ? '(Khung giờ đã có người đặt)'
                        : '';
                    bool isSelectable = !listTimeSlot.contains(index + 1);
                    return ListTile(
                      title: Text('${timeSlots[index]}  $label'),
                      onTap: () {
                        setState(() {
                          _selectedTimeSlot = timeSlots[index];
                          _timeSlot = index + 1;
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
}
