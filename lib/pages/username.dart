import 'package:cuoi_ki_flutter/components/custom_text_field_login.dart';
import 'package:flutter/material.dart';

import '../models/auth.dart';
import 'forgot.dart';

class ForgotPage1 extends StatefulWidget {
  const ForgotPage1({super.key});

  @override
  _ForgotPage1State createState() => _ForgotPage1State();
}

class _ForgotPage1State extends State<ForgotPage1> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  final UserList _listAuth = UserList();

  get index => _listAuth.user.length - 1;
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _listAuth.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 150, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Text(
                'QUÊN MẬT KHẨU?',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 198, 40, 40),
                    fontSize: 20.0),
              ),
              SizedBox(height: 60.0),
              CustomText(
                controller: _usernameController,
                hintText: 'Nhập tên đăng nhập',
                lableText: 'Tên đăng nhập',
              ),
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
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
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red[800])),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _Nhapusername();
                          });
                        }
                      },
                      child: Text('Đặt lại mật khẩu'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _Nhapusername() async {
    final username = _usernameController.text;
    bool user = await _listAuth.isUsernameExist(username, _listAuth.user);
    if (user) {
      _usernameController.clear();

      Route route = MaterialPageRoute(
        builder: (context) => ForgotPage(auth: _listAuth.user[index]),
      );
      await Navigator.push(context, route);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Tên đăng nhập không tồn tại!!'),
            actions: [
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
