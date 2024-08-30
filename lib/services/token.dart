import 'package:get_storage/get_storage.dart';

class TokenService {
  final GetStorage storage = GetStorage();

  void saveToken(String token) {
    print("Saving token: $token"); // Debug print
    storage.write('token', token);
  }

  String? getToken() {
    String? token = storage.read('token');
    print("Retrieved token: $token"); // Debug print
    return token;
  }

  void removeToken() {
    print("Removing token"); // Debug print
    storage.remove('token');
  }

  void saveUserInfo(Map<String, dynamic> user) {
    print("Saving user info: $user"); // Debug print
    storage.write('user_info', user);
  }

  Map<String, dynamic>? getUserInfo() {
    Map<String, dynamic>? userInfo = storage.read('user_info');
    print("Retrieved user info: $userInfo"); // Debug print
    return userInfo;
  }

  void removeUserInfo() {
    print("Removing user info"); // Debug print
    storage.remove('user_info');
  }
}
