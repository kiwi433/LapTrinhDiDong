import 'package:cuoi_ki_flutter/pages/menu_page.dart';
import 'package:flutter/material.dart';

import '../models/auth.dart';

class EditUser extends StatefulWidget {
  final UserModel auth;
  const EditUser({super.key, required this.auth});

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserList _listAuth = UserList();

  late UserModel user;
  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _listAuth.load();
    setState(() {});
  }

  get index => _listAuth.user.length - 1;
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
                  'Thay đổi mật khẩu',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 198, 40, 40),
                      fontSize: 25.0),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: _oldPasswwordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    labelText: 'Mật khẩu cũ',
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
                      return 'Vui lòng nhập mật khẩu';
                    } else if (value != widget.auth.password) {
                      return 'Mật khẩu không đúng';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _newPasswordController,
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
                    } else if (value != _newPasswordController.text) {
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _registerUser();
                      });
                    }
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() {
    final password = _newPasswordController.text;
    if (password != widget.auth.password) {
      _listAuth.editUsername(_listAuth.user[index].id, password);
    }
    UserModel updatedUser = UserModel(
        id: _listAuth.user[index].id,
        username: _listAuth.user[index].username,
        password: password);
    setState(() {
      Route route = MaterialPageRoute(
        builder: (context) => MenuPage(currentUser: updatedUser),
      );
      Navigator.push(context, route);
    });
    _oldPasswwordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    const snackBar = SnackBar(
      content: Text(
        'Đã thay đổi mật khẩu thành công',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
