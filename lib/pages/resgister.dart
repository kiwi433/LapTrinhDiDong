import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';
import 'LoginScreen_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserList _listAuth = UserList();

  @override
  void initState() {
    super.initState();

    // _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _listAuth.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                const Text(
                  'Đăng Ký',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 198, 40, 40),
                      fontSize: 32.0),
                ),
                const SizedBox(height: 26.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    labelText: 'Tên đăng nhập',
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color color = states.contains(MaterialState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.deepPurple;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                  ),
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập tên đăng nhập';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    prefixIconConstraints: const BoxConstraints(minWidth: 26.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    labelText: 'Mật khẩu',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    } else if (value.length < 6) {
                      return 'Ít nhất 6 kí tự';
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    prefixIconConstraints: const BoxConstraints(minWidth: 26.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    labelText: 'Xác nhận lại mật khẩu',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập xác nhận lại mật khẩu';
                    } else if (value != _passwordController.text) {
                      return 'Không khớp với mật khẩu trên';
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey[350])),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red[800])),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _registerUser();
                          });
                        }
                      },
                      child: const Text('Đăng ký'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    bool isExistUser = _listAuth.isUsernameExist(username, _listAuth.user);

    // Navigate to Login page
    if (isExistUser == false) {
      _listAuth.addAuth(username, password);

      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {});
      Route route = MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
      Navigator.pushReplacement(context, route);
      final snackBar = SnackBar(
        content: const Text('Bạn đã đăng kí thành công!!!'),
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
}
