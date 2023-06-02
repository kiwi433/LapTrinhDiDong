import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class UserModel {
  int id;
  String username;
  String password;

  UserModel({required this.id, required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] as int,
        username: json['username'] as String,
        password: json['password'] as String);
  }
}

class UserList {
  List<UserModel> _user = [];
  UserList() {
    load();
  }

  List<UserModel> get user => _user;

  Future<void> addAuth(
    String username,
    String password,
  ) async {
    final int lastId = _user.isEmpty ? 0 : _user.last.id;
    final UserModel newAuth = UserModel(
      id: lastId + 1,
      username: username,
      password: password,
    );
    _user.add(newAuth);

    final prefs = await SharedPreferences.getInstance();
    List<String> authsJson = _user.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('auths', authsJson);
  }

  bool isUsernameExist(String username, List<UserModel> authList) {
    return _user.where((auth) => auth.username == username).isNotEmpty;
  }

  bool isPasswwordExist(String password, List<UserModel> authList) {
    return authList.where((auth) => auth.password == password).isNotEmpty;
  }

  checkusername(String id, String username, List<UserModel> authList) {
    return authList.where((auth) => auth.id == id);
  }

  Future<void> editUsername(int id, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Load the list of products from storage
    List<String> authsJson = prefs.getStringList('auths') ?? [];
    final auths =
        authsJson.map((p) => UserModel.fromJson(jsonDecode(p))).toList();

    // Find the product with the specified ID
    final authIndex = auths.indexWhere((a) => a.id == id);
    if (authIndex == -1) {
      print('Auth with ID $id not found');
      return;
    }

    // Update the status of the product
    auths[authIndex].password = password;

    // Update the list of products in storage
    authsJson = auths.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('auths', authsJson);
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> authsJson = prefs.getStringList('auths') ?? [];

    _user = authsJson.map((p) => UserModel.fromJson(jsonDecode(p))).toList();
    try {
      _user = authsJson.map((p) => UserModel.fromJson(jsonDecode(p))).toList();
    } catch (error) {
      print('Error loading products: $error');
      _user = [];
    }
    print("du liệu user $_user");
  }

  Future<void> deleteProduct(int id) async {
    _user.removeWhere((product) => product.id == id);
    final prefs = await SharedPreferences.getInstance();
    List<String> authsJson = _user.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('auths', authsJson);
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> authenticate(String username, String password) async {
    // Tìm thông tin đăng nhập của người dùng
    final userAuth = _user.firstWhere((auth) => auth.username == username);

    if (userAuth == null) {
      return false; // Username không tồn tại trong danh sách người dùng
    }

    // Kiểm tra mật khẩu người dùng
    final bool isMatch = userAuth.password == password;
    return isMatch;
    // Trả về kết quả xác thực thông tin đăng nhập
  }

  List<UserModel> userModelFromJson(String jsonString) {
    final jsonData = json.decode(jsonString);
    final List<dynamic> dataList = jsonData.values.toList();
    return dataList.map((json) => UserModel.fromJson(json)).toList();
  }

  UserModel? getUserWithId(int id) {
    return _user.firstWhereOrNull((user) => user.id == id);
  }

  UserModel? getUserWithusername(String username) {
    return _user.firstWhereOrNull((user) => user.username == username);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in');

    if (isLoggedIn == true) {
      final int userId = prefs.getInt('user_id') ?? -1;
      final user = getUserWithId(userId);
      if (user != null) {
        return user;
      }

      return null;
    }
  }
}
