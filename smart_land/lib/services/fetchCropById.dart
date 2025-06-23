import 'package:dio/dio.dart';
import 'package:smart_land/services/CropAPi.dart'; 

Future<Crop> fetchCropById(int id) async {
  try {
    final dio = Dio();
    final response = await dio
        .get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Crops/$id');

    if (response.statusCode == 200) {
      return Crop.fromJson(response.data);
    } else {
      throw Exception('Failed to load crop: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching crop: $e');
  }
}