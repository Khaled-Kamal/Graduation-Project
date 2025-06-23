import 'package:dio/dio.dart';

class ResetPasswordService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/',
      //https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/reset-password
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<String> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token, 
  }) async {
    try {
      final response = await _dio.post(
        'Auth/reset-password',
        data: {
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return "Password reset successfully.";
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