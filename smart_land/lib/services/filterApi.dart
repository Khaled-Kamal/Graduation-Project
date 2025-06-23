
   import 'package:dio/dio.dart';

class Fertilizer {
  final int id;
  final String name;
  final String type;
  final String imageUrl;

  Fertilizer({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Crop {
  final int id;
  final String name;
  final String scientificName;
  final String description;
  final String season;
  final String soilType;
  final String waterNeeds;
  final String cropType;
  final String imageUrl;
  final String temperatureRange;
  final List<Fertilizer> compatibleFertilizers;

  Crop({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.season,
    required this.soilType,
    required this.waterNeeds,
    required this.cropType,
    required this.imageUrl,
    required this.temperatureRange,
    required this.compatibleFertilizers,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      description: json['description'],
      season: json['season'],
      soilType: json['soilType'],
      waterNeeds: json['waterNeeds'],
      cropType: json['cropType'],
      imageUrl: json['imageUrl'],
      temperatureRange: json['temperatureRange'],
      compatibleFertilizers: (json['compatibleFertilizers'] as List)
          .map((item) => Fertilizer.fromJson(item))
          .toList(),
    );
  }
}

// API Response Model
class ApiResponse {
  final String status;
  final int results;
  final List<Crop> data;
  final Map<String, dynamic> appliedFilters;

  ApiResponse({
    required this.status,
    required this.results,
    required this.data,
    required this.appliedFilters,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      results: json['results'],
      data: (json['data'] as List)
          .map((item) => Crop.fromJson(item))
          .toList(),
      appliedFilters: Map<String, dynamic>.from(json['appliedFilters']),
    );
  }
}

// API Service using Dio

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Search/filter';

  Future<ApiResponse> fetchCrops(Map<String, String> filters) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: filters,
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load crops: $e');
    }
  }
}