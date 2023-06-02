import 'package:flutter/material.dart';

import '../models/auth.dart';
import 'LoginScreen_page.dart';

class ForgotPage extends StatefulWidget {
  final UserModel auth;
  const ForgotPage({super.key, required this.auth});

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserList _listAuth = UserList();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData.fallback(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 198, 40, 40),
                      fontSize: 25.0),
                ),
                const SizedBox(height: 50.0),
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
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color color = states.contains(MaterialState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.deepPurple;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    labelText: 'Mật khẩu mới',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
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
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color color = states.contains(MaterialState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.deepPurple;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
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
                  child: const Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() {
    final password = _passwordController.text;

    // Navigate to Login page

    _listAuth.editUsername(widget.auth.id, password);

    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    Route route = MaterialPageRoute(
      builder: (context) => LoginPage(),
    );
    Navigator.push(context, route);
    final snackBar = SnackBar(
      content: Text(
        'Đặt lại mật khẩu thành công',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
