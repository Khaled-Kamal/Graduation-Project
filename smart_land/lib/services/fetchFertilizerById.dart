import 'package:dio/dio.dart';
import 'package:smart_land/services/fertliizerAPi.dart'; 

Future<Fertilizer> fetchFertilizerById(int id) async {
  try {
    final dio = Dio();
    final response = await dio
        .get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Fertilizers/$id');

    if (response.statusCode == 200) {
      return Fertilizer.fromJson(response.data);
    } else {
      throw Exception('Failed to load fertilizer: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching fertilizer: $e');
  }
}