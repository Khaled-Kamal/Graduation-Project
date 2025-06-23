import 'package:dio/dio.dart';

class Plant {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Plant({required this.id, required this.name, required this.description, required this.imageUrl});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Crop {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Crop({required this.id, required this.name, required this.description, required this.imageUrl});

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Fertilizer {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Fertilizer({required this.id, required this.name, required this.description, required this.imageUrl});

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class HomeResponse {
  final bool isGuest;
  final List<Plant> plants;
  final List<Crop> crops;
  final List<Fertilizer> fertilizers;

  HomeResponse({required this.isGuest, required this.plants, required this.crops, required this.fertilizers});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      isGuest: json['isGuest'],
      plants: List<Plant>.from(json['plants'].map((x) => Plant.fromJson(x))),
      crops: List<Crop>.from(json['crops'].map((x) => Crop.fromJson(x))),
      fertilizers: List<Fertilizer>.from(json['fertilizers'].map((x) => Fertilizer.fromJson(x))),
    );
  }
}

Future<HomeResponse> fetchHomeData() async {
  const String apiUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Home';
  final dio = Dio();
  try {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return HomeResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load home data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}