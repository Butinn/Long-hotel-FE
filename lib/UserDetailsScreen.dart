import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/UserEditScreen.dart';
import 'package:my_app/home.dart';
import 'package:my_app/list_user.dart';
import 'package:my_app/model/user.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;
  final User userLogin;
  final String backgroundImage = 'background.PNG';
  UserDetailsScreen({required this.user, required this.userLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết người dùng'),
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
                'ID: ${user.id}',
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
                'Họ tên: ${user.fullname}',
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
                'Email: ${user.email}',
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
                'Số điện thoại: ${user.phone_number}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Chuyển sang trang cập nhật thông tin người dùng
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserEditScreen(
                              userDetail: user,
                              userLogin: userLogin,
                            ),
                          ),
                        );
                      },
                      child: Text('Sửa'),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Visibility(
                    visible: userLogin.userType == 1,
                    // true: hiển thị widget, false: ẩn widget
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút Xóa
                          _deleteUser(context);
                        },
                        child: Text('Xóa'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context) async {
    // Hiển thị hộp thoại xác nhận
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa người dùng'),
          content: Text('Bạn có chắc chắn muốn xóa người dùng này?'),
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
      deleteUser(user.id, context);
      print('xóa user');
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
      print('không xóa user nữa');
    }
  }

  Future<void> deleteUser(int userId, BuildContext context) async {
    final url = 'http://localhost:8080/api/user/delete/$userId';

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
