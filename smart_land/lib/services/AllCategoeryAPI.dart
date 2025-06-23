import 'package:dio/dio.dart';

class Item {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String type;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
    );
  }
}

class CombinedEntitiesResponse {
  final List<Item> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  CombinedEntitiesResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory CombinedEntitiesResponse.fromJson(Map<String, dynamic> json) {
    return CombinedEntitiesResponse(
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<CombinedEntitiesResponse> fetchCombinedEntities({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        'CombinedEntities',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      return CombinedEntitiesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCropById(int id) async {
    try {
      final response = await _dio.get('Crops/$id');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load crop: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching crop: $e');
    }
  }

  Future<Map<String, dynamic>> fetchFertilizerById(int id) async {
    try {
      final response = await _dio.get('Fertilizers/$id');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load fertilizer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching fertilizer: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPlantById(int id) async {
    try {
      final response = await _dio.get('Plants/$id');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plant: $e');
    }
  }
}