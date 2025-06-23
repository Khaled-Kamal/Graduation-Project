import 'package:dio/dio.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/',
      // https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/login
     
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'Auth/register',
        data: {
          'FullName': fullName,
          'Email': email,
          'Password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success", "message": "User registered successfully."};
      } else {
        return {"status": "failed", "message": "Unexpected error: ${response.statusCode}"};
      }
    } on DioException catch (e) {
      return {"status": "failed", "message": "Error: ${e.response?.data ?? e.message}"};
    } catch (e) {
      return {"status": "failed", "message": "Unexpected error: $e"};
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'Auth/login',
        data: {
          'Email': email,
          'Password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token']; 
        return {"status": "success", "token": token};
      } else {
        return {"status": "failed", "message": "Login failed: ${response.statusCode}"};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {"status": "failed", "message": "Login error: ${e.response?.data}"};
      } else {
        return {"status": "failed", "message": "Connection error: ${e.message}"};
      }
    } catch (e) {
      return {"status": "failed", "message": "Unexpected error: $e"};
    }
  }
}