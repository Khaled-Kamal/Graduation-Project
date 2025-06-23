import 'package:dio/dio.dart';

class ForgotPasswordService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/',
      //https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/forgot-password
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<String> forgotPassword({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        'Auth/forgot-password',
        data: {
          'Email': email,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return "Reset code sent to your email.";
      } else {
        return "Unexpected error: ${response.statusCode}";
      }
    } on DioException catch (e) {
      return "Error: ${e.response?.data ?? e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }
}