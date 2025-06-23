import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:smart_land/Models/ProfileOptions.dart';
import 'package:smart_land/pages_Profiles/EditProfilePage.dart';
import 'package:smart_land/pages_Profiles/AboutUs.dart';
import 'package:smart_land/pages_Profiles/FAQS.dart';
import 'package:smart_land/pages_Profiles/TermsAndConditionsPage.dart';
import 'package:smart_land/pages_Profiles/contant.dart';
import 'package:smart_land/pages_Profiles/privacy.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? token;
  String? fullName;
  String? email;
  String? profilePictureUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndProfile();
  }

  Future<void> _loadTokenAndProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    print('Token retrieved: $token'); // For debugging

    if (token == null) {
      setState(() {
        fullName = 'No Name';
        email = 'No Email';
        isLoading = false;
      });
      return;
    }

    await _getProfileData();
  }

  Future<void> _getProfileData() async {
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
          fullName = data['fullName'] ?? 'No Name';
          email = data['email'] ?? 'No Email';
          profilePictureUrl = data['profilePictureUrl'] != null
              ? 'https://48pmt2mt-7016.uks1.devtunnels.ms${data['profilePictureUrl']}'
              : null;
          isLoading = false;
        });
        // Save to SharedPreferences for HomeScreen
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', fullName ?? 'No Name');
        await prefs.setString('profile_picture_url', profilePictureUrl ?? '');
      } else {
        print('فشل في تحميل البيانات: ${response.statusCode} - ${response.data}');
        setState(() {
          fullName = 'No Name';
          email = 'No Email';
          isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ أثناء الاتصال: $e');
      setState(() {
        fullName = 'No Name';
        email = 'No Email';
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePictureUrl != null && profilePictureUrl!.isNotEmpty
                        ? NetworkImage(profilePictureUrl!)
                        : const AssetImage('assets/PROFILE.png') as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    fullName ?? 'Khaled Kamal',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    email ?? 'KhaledKamal14@gmail.com',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileOption(
                          icon: Icons.edit,
                          title: "Edit Profile",
                          page: EditProfilePage(),
                          onTap: () async {
                            final updatedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(),
                              ),
                            );

                            if (updatedData != null) {
                              setState(() {
                                fullName = '${updatedData['firstName']} ${updatedData['lastName']}';
                                email = updatedData['email'];
                                profilePictureUrl = updatedData['imageUrl'];
                              });
                              await _getProfileData(); // Refresh data from API
                            }
                          },
                        ),
                        const SizedBox(height: 5),
                        ProfileOption(
                          icon: Icons.phone,
                          title: "Contact us",
                          page: ContactUsPage(),
                        ),
                        const SizedBox(height: 5),
                        ProfileOption(
                          icon: Icons.info,
                          title: "About us",
                          page: AboutUsPage(),
                        ),
                        const SizedBox(height: 5),
                        ProfileOption(
                          icon: Icons.description,
                          title: "Terms and conditions",
                          page: TermsAndConditionsPage(),
                        ),
                        const SizedBox(height: 5),
                        ProfileOption(
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy",
                          page: PrivacyPolicyPage(),
                        ),
                        const SizedBox(height: 5),
                        ProfileOption(
                          icon: Icons.lightbulb_outline,
                          title: "FAQS",
                          page: FactsPage(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB3E3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: logout,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}