import 'package:dio/dio.dart';

class Crop {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String? scientificName; 
  final String? temperatureRange; 
  final String? waterNeeds; 
  final String? soilType; 

  Crop({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.scientificName,
    this.temperatureRange,
    this.waterNeeds,
    this.soilType,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms'; 
    String imagePath = json['imageUrl'] ?? '';
    String fullImageUrl = imagePath.startsWith('http') ? imagePath : '$baseUrl$imagePath';

    return Crop(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: fullImageUrl,
      scientificName: json['scientificName'] as String?,
      temperatureRange: json['temperatureRange'] as String?,
      waterNeeds: json['waterNeeds'] as String?,
      soilType: json['soilType'] as String?,
    );
  }
}

Future<List<Crop>> fetchCrops() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Crops');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => Crop.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load crops: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load crops: $e');
  }
}

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