import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/ScheduleEditScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/list_schedule.dart';
import 'package:my_app/model/schedule.dart';
import 'package:my_app/model/user.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  final Schedule schedule;
  final String backgroundImage = 'background.PNG';
  List<String> timeSlots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '2:00 PM - 4:00 PM',
  ];
  ScheduleDetailsScreen({required this.schedule, required this.userLogin});

  final User userLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết lượt khám'),
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
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40,80,8,8),
              child: Text(
                'ID lượt khám: ${schedule.id}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,8,8),
              child: Text(
                'Họ và tên: ${schedule.fullname}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,8,8),
              child: Text(
                'Số điện thoại: ${schedule.phoneNumber}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,8,8),
              child: Text(
                'Ghi chú: ${schedule.note}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,8,8),
              child: Text(
                'Ngày hẹn: ${schedule.appointmentTime}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,8,8),
              child: Text(
                'Khung giờ: ${timeSlots[schedule.timeSlot-1]}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Sửa
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduleEditScreen(
                                  userLogin: userLogin,
                                  scheduleDetail: schedule,
                                )),
                      );
                    },
                    child: Text('Sửa'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Xóa
                      _deleteSchedule(context);
                    },
                    child: Text('Xóa'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _deleteSchedule(BuildContext context) async {
    // Hiển thị hộp thoại xác nhận
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa Phòng'),
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
      deleteSchedule(schedule.id, context);
      print('xóa lượt khám');
      // Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(userLogin: userLogin)),
      );
    } else {
      print('không xóa lượt khám nữa');
    }
  }

  Future<void> deleteSchedule(int scheduleId, BuildContext context) async {
    final url =
        'http://192.168.0.143:8080/api/schedule/xoa-lich-kham/$scheduleId';
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
