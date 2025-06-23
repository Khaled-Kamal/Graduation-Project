import 'package:dio/dio.dart';

class Fertilizer {
  final int id;
  final String name;
  final String description;
  final String type;
  final String nitrogenContent;
  final String phosphorusContent;
  final String potassiumContent;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  Fertilizer({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.nitrogenContent,
    required this.phosphorusContent,
    required this.potassiumContent,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      nitrogenContent: json['nitrogenContent'] as String,
      phosphorusContent: json['phosphorusContent'] as String,
      potassiumContent: json['potassiumContent'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as int,
    );
  }
}

Future<List<Fertilizer>> fetchFertilizers() async {
  try {
    final dio = Dio();
    final response = await dio
        .get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/Fertilizers');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Fertilizer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load fertilizers: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching fertilizers: $e');
  }
}