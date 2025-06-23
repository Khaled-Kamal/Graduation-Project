import 'package:dio/dio.dart';
import 'dart:io';

Future<void> updateProfile({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  File? imageFile, 
}) async {
  final dio = Dio();
  String apiUrl = 'https://z053t98w-7016.uks1.devtunnels.ms/api/Auth/update-profile';

  try {
    var formData = FormData.fromMap({
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
    });

    if (imageFile != null) {
      formData.files.add(
        MapEntry(
          'UploadedFile',
          await MultipartFile.fromFile(imageFile.path, filename: 'profile_image.jpg'),
        ),
      );
    }

    var response = await dio.post(
      apiUrl,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully: ${response.data}');
    } else {
      print('Failed to update profile: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating profile: $e');
  }
}