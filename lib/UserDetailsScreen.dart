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
  final String backgroundImage = 'assets/background.jpg';
  UserDetailsScreen({required this.user, required this.userLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set your desired background color here
        title: Text('Chi tiết người dùng',
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
              MaterialPageRoute(builder: (context) => MyHomePage(userLogin: userLogin)),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/avatar.jpg', // Provide your image path here
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
              buildDetailItem('ID', '${user.id}'),
              buildDetailItem('Họ tên', '${user.fullname}'),
              buildDetailItem('Email', '${user.email}'),
              buildDetailItem('Số điện thoại', '${user.phone_number}'),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Button border radius
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Visibility(
                    visible: userLogin.userType == 1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Xóa
                        _deleteUser(context);
                      },
                      child: Text('Xóa'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Button border radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: Colors.grey[800],
            ),
          ),
        ],
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
    final url = 'http://192.168.0.143:8080/api/user/delete/$userId';

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
