import 'package:dio/dio.dart';

class Plant {
  final int id;
  final String name;
  final String scientificName;
  final String description;
  final String lightRequirements;
  final String temperatureRange;
  final String waterNeeds;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  final int userId;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.lightRequirements,
    required this.temperatureRange,
    required this.waterNeeds,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Plant',
      scientificName: json['scientificName'] ?? '',
      description: json['description'] ?? 'No description available.',
      lightRequirements: json['lightRequirements'] ?? '',
      temperatureRange: json['temperatureRange'] ?? '',
      waterNeeds: json['waterNeeds'] ?? '',
      imageUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms${json['imageUrl'] ?? '/uploads/placeholder.jpg'}',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      userId: json['userId'] ?? 0,
    );
  }
}

Future<List<Plant>> fetchPlants() async {
  final Dio dio = Dio();
  try {
    final response = await dio.get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Plants');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Plant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  } catch (e) {
    throw Exception('Error fetching plants: $e');
  }
}