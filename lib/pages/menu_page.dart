import 'package:cuoi_ki_flutter/models/auth.dart';
import 'package:cuoi_ki_flutter/pages/edit_user.dart';
import 'package:cuoi_ki_flutter/pages/home_page.dart';
import 'package:cuoi_ki_flutter/pages/search_page.dart';
import 'package:cuoi_ki_flutter/pages/thongke.dart';
import 'package:cuoi_ki_flutter/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen_page.dart';

class MenuPage extends StatefulWidget {
  final UserModel currentUser;

  const MenuPage({
    super.key,
    required this.currentUser,
  });

  set currentUser1(UserModel currentUser1) {}

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final UserList _listAuth = UserList();

  get index => _listAuth.user.length;
  final SharedPrefs _sharedPrefs = SharedPrefs();
  int _selectedIndex = 0;

  final bool _isLoggedIn = false;
  final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    const Thongke(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadProducts();
    });
    print('Username đang đăng nhập ${widget.currentUser.username}');
  }

  Future<void> _loadProducts() async {
    await _sharedPrefs.load();
    setState(() {});
  }

  _logout() async {
    if (_isLoggedIn == false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      prefs.setBool('is_logged_in', false);
      setState(() {});
      Route route = MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.pushAndRemoveUntil(context, route, (_) => false);
    } else {
      return null;
    }
  }

  void _showlogout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bạn có muốn thoát app không?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Không'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Có'),
                  onPressed: () async {
                    _logout();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[800],
        title: CircleAvatar(
          child: TextButton(
              child: Text(
                '${widget.currentUser.username[0]}',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
              onPressed: () async {
                // Xử lý khi người dùng bấm nút trái
                !_isLoggedIn
                    // ignore: use_build_context_synchronously
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Xin chào ${widget.currentUser.username}'),
                              ],
                            ),
                            content: Container(
                              height: 80.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text('Tên đăng nhập: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('${widget.currentUser.username}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Mật khẩu: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('${widget.currentUser.password}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Đóng'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: const Text('Thay đổi mật khẩu'),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditUser(
                                            auth: widget.currentUser,
                                          ),
                                        ));
                                  }),
                            ],
                          );
                        },
                      )
                    : Text('Không có chi${widget.currentUser.username}');
              }),
        ),
        actions: [
          if (!_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showlogout();
              },
            )
          else
            Text(''),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.red[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Thong ke',
          ),
        ],
      ),
    );
  }
}
