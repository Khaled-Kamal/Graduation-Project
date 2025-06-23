import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedCountryCode = "+20"; // Default country code
  File? profilePictureFile;
  bool isLoading = true;
  String? token;
  String? originalFirstName;
  String? originalLastName;
  String? originalEmail;
  String? originalPhone;

  @override
  void initState() {
    super.initState();
    _loadTokenAndInitialProfileData();
  }

  Future<void> _loadTokenAndInitialProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    print('Token retrieved: $token'); // For debugging

    if (token == null) {
      setState(() {
        firstNameController.text = 'Khalid';
        lastNameController.text = 'Ghonem';
        emailController.text = 'Khalid_ghonem@gmail.com';
        phoneController.text = '1187167970';
        isLoading = false;
      });
      return;
    }

    try {
      var dio = Dio();
      var response = await dio.get(
        'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          originalFirstName = data['fullName']?.split(' ')[0] ?? 'Khalid';
          originalLastName = data['fullName']?.split(' ')[1] ?? 'Ghonem';
          originalEmail = data['email'] ?? 'Khalid_ghonem@gmail.com';
          originalPhone = data['phone']?.replaceFirst(RegExp(r'^\+\d+\s?'), '') ?? '1187167970';

          firstNameController.text = originalFirstName!;
          lastNameController.text = originalLastName!;
          emailController.text = originalEmail!;
          phoneController.text = originalPhone!;
          selectedCountryCode = data['phone']?.startsWith('+20') == true ? '+20' : '+1';
          isLoading = false;
        });
      } else {
        print('فشل في تحميل البيانات الأصلية: ${response.statusCode}');
        setState(() {
          firstNameController.text = 'Khalid';
          lastNameController.text = 'Ghonem';
          emailController.text = 'Khalid_ghonem@gmail.com';
          phoneController.text = '1187167970';
          isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ أثناء تحميل البيانات: $e');
      setState(() {
        firstNameController.text = 'Khalid';
        lastNameController.text = 'Ghonem';
        emailController.text = 'Khalid_ghonem@gmail.com';
        phoneController.text = '1187167970';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profilePictureFile != null
                              ? FileImage(profilePictureFile!)
                              : AssetImage('assets/PROFILE.png') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1565C0),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(6),
                            child: IconButton(
                              icon: Icon(Icons.edit, size: 16, color: Colors.white),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("First name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 8),
                            _buildInputField("First Name", firstNameController),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Last name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 8),
                            _buildInputField("Last Name", lastNameController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Email",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  _buildInputField("Email", emailController),
                  SizedBox(height: 16),
                  Text("Phone",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedCountryCode,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountryCode = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: const [
                            DropdownMenuItem(value: "+20", child: Text("+20")),
                            DropdownMenuItem(value: "+1", child: Text("+1")),
                            DropdownMenuItem(value: "+44", child: Text("+44")),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(child: _buildInputField("Phone", phoneController)),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFFEB3E3E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFEB3E3E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profilePictureFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (token == null) {
      print('No token available');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'FirstName': firstNameController.text,
        'LastName': lastNameController.text,
        'Email': emailController.text,
        'Phone': '$selectedCountryCode${phoneController.text}',
      });

      if (profilePictureFile != null) {
        formData.files.add(
          MapEntry(
            'UploadedFile',
            await MultipartFile.fromFile(
              profilePictureFile!.path,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg', // Unique filename
            ),
          ),
        );
        print('Uploading file: ${profilePictureFile!.path}');
      }

      var response = await dio.put(
        'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Auth/update-profile',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully: ${response.data}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name',
            '${firstNameController.text} ${lastNameController.text}');
        await prefs.setString('user_email', emailController.text);

        String? newImageUrl = response.data['profilePictureUrl'] != null
            ? 'https://48pmt2mt-7016.uks1.devtunnels.ms${response.data['profilePictureUrl']}'
            : null;

        Navigator.pop(context, {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'phone': '$selectedCountryCode${phoneController.text}',
          'imageUrl': newImageUrl,
        });
      } else {
        print('فشل في الحفظ: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('خطأ أثناء الحفظ: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}