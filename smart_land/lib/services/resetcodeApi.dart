import 'package:dio/dio.dart';

class VerifyCodeService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/',
      //https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/verify-code
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<String> verifyCode({
    required String email,
    required String code, 
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        'Auth/verify-code',
        data: {
          'Email': email,
          'Code': code, 
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', 
          },
        ),
      );

      if (response.statusCode == 200) {
        return "Code verified successfully.";
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