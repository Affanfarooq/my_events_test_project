import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

// Task Requirement: Secure Storage for tokens
class StorageService extends GetxService {
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  // --- Keys ---
  static const String _authTokenKey = 'auth_token';
  static const String _rememberMeEmailKey = 'remember_me_email';

  // --- Auth Token ---
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }
  
  // Task Requirement: Remember me
  Future<void> saveRememberMeEmail(String email) async {
    await _storage.write(key: _rememberMeEmailKey, value: email);
  }
  
  Future<String?> getRememberMeEmail() async {
    return await _storage.read(key: _rememberMeEmailKey);
  }
  
  Future<void> clearRememberMeEmail() async {
    await _storage.delete(key: _rememberMeEmailKey);
  }
}