import 'package:flutter/material.dart';
import 'package:smart_land/Models/BulletPoint.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      //Privacy Policy
      body:  const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title: Logipsum
            Center(
              child: Text(
                'Logipsum',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF2E7D32),
                ),
              ),
            ),
            SizedBox(height: 45),

            // Welcome message
            Text(
              'Welcome to SmartLand! Your privacy is important to us. This policy explains how we collect, use, and protect your information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 39),

            // Section 1: Information We Collect
            Text(
              '1. Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'Location Data: Used to analyze land suitability (not stored permanently).'),
            BulletPoint(text: 'Device Information: Helps improve app performance and user experience.'),
            SizedBox(height: 16),

            // Section 2: How We Use Your Data
            Text(
              '2. How We Use Your Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'To provide accurate AI-powered land analysis.'),
            BulletPoint(text: 'To enhance app functionality and user support.'),
            SizedBox(height: 16),

            // Section 3: Data Security
            Text(
              '3. Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'We do not sell or share your personal information.'),
            BulletPoint(text: 'Your data is securely processed and protected.'),
            SizedBox(height: 16),

            // Section 4: Your Rights
            Text(
              '4. Your Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'You can request data deletion at any time.'),
            BulletPoint(text: 'By using SmartLand, you agree to this policy.'),
          ],
        ),
      ),
    );
  }
}

