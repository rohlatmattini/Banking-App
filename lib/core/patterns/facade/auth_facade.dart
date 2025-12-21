

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/apis/auth/auth_api.dart';
import '../../../data/models/auth/signin_model.dart';
import '../../../data/models/auth/user_model.dart';
import '../../services/auth/user_service.dart';

class AuthFacade {
  final AuthApi api;
  final FlutterSecureStorage storage;
  final UserService userService;

  AuthFacade({
    required this.api,
    required this.storage,
    required this.userService,
  });

  Future<UserModel?> login(LoginModel model) async {
    final response = await api.login(model);

    if (response == null || response['user'] == null) return null;

    final token = response['token'];
    final userData = response['user'];

    if (token != null) await storage.write(key: 'token', value: token);

    final user = UserModel(
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
    );

    await userService.saveUser(user);

    return user;
  }


  Future<UserModel?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // قراءة التوكن المخزن
    final token = await storage.read(key: 'token');
    if (token == null) return null;

    // استدعاء API
    final response = await api.changePassword(
      token: token,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (response == null || response['user'] == null) return null;

    final userData = response['user'];
    final user = UserModel(
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
    );

    // تحديث بيانات المستخدم محلياً
    await userService.saveUser(user);

    return user;
  }

  Future<bool> logout() async {
    final token = await storage.read(key: 'token');
    if (token == null) return false;

    final response = await api.logout(token: token);

    if (response != null && response['error'] == null) {
      // إزالة التوكن وبيانات المستخدم محلياً
      await storage.delete(key: 'token');
      await userService.clearUser();
      return true;
    }
    return false;
  }
}
