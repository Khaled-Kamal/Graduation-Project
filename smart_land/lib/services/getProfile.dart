import 'package:dio/dio.dart';

Future<Map<String, dynamic>> getProfileData(String token) async {
  try {
    var dio = Dio();
    var response = await dio.get(
      'https://z053t98w-7016.uks1.devtunnels.ms/api/Auth/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return {"status": "success", "data": response.data};
    } else {
      return {"status": "failed", "message": "Failed to load profile: ${response.statusCode}"};
    }
  } catch (e) {
    return {"status": "failed", "message": "Error: $e"};
  }
}