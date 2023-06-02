import 'dart:async';
import 'package:cuoi_ki_flutter/pages/LoginScreen_page.dart';
import 'package:cuoi_ki_flutter/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    Timer(
      const Duration(seconds: 2),
      () {
        _loadProducts();
        _loadPrefs();
        _loadCurrentUser();
      },
    );
  }

  final UserList _listAuth = UserList();

  late UserModel _currentUser;

  void _loadCurrentUser() async {
    UserModel? user = await _listAuth.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
        print(_currentUser.username);
      });
    } else {
      print('Không có người dùng nào đăng nhập');
    }
  }

  Future<void> _loadProducts() async {
    await _listAuth.load();
    setState(() {});
  }

  bool _isLoggedIn = false;

// Hàm lấy dữ liệu từ Shared Preferences khi đăng nhập
  _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    UserModel? user = await _listAuth.getCurrentUser();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    // Lấy dữ liệu tên 'name' đã lưu trữ (nếu có) để kiểm tra đã đăng nhập hay chưa
    if (_isLoggedIn != isLoggedIn && user != null) {
      // Nếu tìm thấy 'name' thì đánh dấu là đã đăng nhập

      print('${isLoggedIn}');
      // ignore: use_build_context_synchronously

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MenuPage(
                  currentUser: _currentUser!,
                )),
      );
    } else {
      Route route = MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
      Navigator.pushReplacement(context, route);
    }
  }

  Future<void> _checkIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<void> _handleLogout() async {
    // Xóa trạng thái đăng nhập và cập nhật UI
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return MenuPage(
          currentUser:
              _currentUser); // trả về trang MenuPage nếu người dùng đã đăng nhập
    }
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/SELL BOOK (2).png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Center(
            child: Image.asset(
              'assets/images/zyro-image (1).png',
              width: 400.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
