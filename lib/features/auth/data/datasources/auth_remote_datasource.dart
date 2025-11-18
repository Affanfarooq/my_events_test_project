import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<String> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  final Dio _dio = Get.find(tag: 'reqres'); 

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data['token'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Login failed');
    }
  }

  @override
  Future<String> register(String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
      });
      return response.data['token'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Registration failed');
    }
  }
}