import 'dart:convert';

import 'package:cuoi_ki_flutter/models/auth.dart';
import 'package:cuoi_ki_flutter/pages/resgister.dart';
import 'package:cuoi_ki_flutter/pages/username.dart';
import 'package:flutter/material.dart';

import '../components/custom_text_field_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserList _listAuth = UserList();
  late UserModel _currentUser;
  get index => _listAuth.user.length - 1;
  bool _canRegister = false;
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();

    _loadProducts();
    SharedPreferences.getInstance().then((prefs) {
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      print("${isLoggedIn}");
      _onInputChange();

      setState(() {
        _isLoggedIn = !isLoggedIn;
      });
    });
  }

  void _loadCurrentUser() async {
    final user = await _listAuth.getCurrentUser();
    setState(() {
      _currentUser = user!;
    });
  }

  Future<void> _loadProducts() async {
    await _listAuth.load();
    setState(() {});
  }

  void _onInputChange() {
    if (_listAuth.user.isEmpty) {
      _canRegister = true;
    } else if (_listAuth.user.isNotEmpty) {
      _canRegister = false;
    }
    setState(() {});
  }

  int _indexid = 1;
  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    UserModel auth =
        UserModel(id: _indexid++, username: username, password: password);

    bool isExistUser = _listAuth.isUsernameExist(username, _listAuth.user);
    bool isExistPass = _listAuth.isPasswwordExist(password, _listAuth.user);

    if (isExistUser && isExistPass) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setInt('user_id', auth.id as int);
      final user = await _listAuth.getCurrentUser();
      setState(() {
        _isLoggedIn = true;
      });
      _currentUser = user ??
          UserModel(
            id: user!.id,
            username: '${user.username}',
            password: '${user.password}',
          );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MenuPage(
                    currentUser: _currentUser,
                  )));

      final snackBar = SnackBar(
        content: Text(
          'Bạn đã đăng nhập thành công với ${auth.username}',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Nếu xác thực không thành công, hiển thị thông báo lỗi
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Sai username hoặc password'),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 110.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 26.0),
                const Text(
                  'Đăng nhập',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 198, 40, 40),
                      fontSize: 32.0),
                ),
                const SizedBox(height: 36.0),
                CustomText(
                  controller: _usernameController,
                  hintText: 'Nhập tên đăng nhập',
                  icon: Icons.account_circle,
                  lableText: 'Tên đăng nhập',
                ),
                const SizedBox(height: 26.0),
                CustomText(
                  controller: _passwordController,
                  hintText: 'Nhập mật khẩu',
                  icon: Icons.ac_unit_sharp,
                  obscureText: true,
                  lableText: 'Mật khẩu',
                ),
                const SizedBox(height: 50.0),
                Container(
                  height: 40,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.red[800])),
                    child: const Text('Đăng nhập'),
                    onPressed: () {
                      _login();
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        //forgot password screen

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPage1()));
                        setState(() {});
                      },
                      child: Text(
                        'Quên mật khẩu? | ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _canRegister
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()))
                            : null;
                        setState(() {});
                      },
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _canRegister ? Colors.red[800] : Colors.grey,
                        ),
                      ),
                      //signup screen
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),   // ListView.builder(
                //   reverse: true,
                //   physics: const NeverScrollableScrollPhysics(), //khoa cuon
                //   shrinkWrap: true,
                //   padding: EdgeInsets.zero,

                //   itemCount: _listAuth.user?.length ?? 0,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Column(
                //       children: [
                //         ListTile(
                //           title: Text(_listAuth.user[index].username!),
                //           subtitle: Row(
                //             children: [
                //               Text(
                //                 'id: ${_listAuth.user[index].id!},Price: ${_listAuth.user[index].password!}',
                //               ),
                //               ElevatedButton(
                //                   onPressed: () {
                //                     _listAuth.deleteProduct(
                //                         _listAuth.user[index].id!);
                //                     setState(() {});
                //                   },
                //                   child: Text('Xóa'))
                //             ],
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // ),


              ],
            ),
          ),
        );
      }),
    );
  }
}
