import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await _dio
          .get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Notifications');
      if (response.statusCode == 200) {
        final data = response.data;
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}