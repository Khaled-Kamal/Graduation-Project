import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Logoipsum',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            SizedBox(height:60),
            Text(
              'About SmartLand',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: 'Welcome to '),
                  TextSpan(
                    text: 'SmartLand',
                    style: TextStyle(color: Color(0xFF2E7D32),),
                  ),
                  TextSpan(
                      text:
                          '! We’re here to make land evaluation simple and accurate. Our AI-powered platform helps you determine the best use for any land—whether for agriculture, construction, or industry. Just enter a location, and we’ll provide instant insights to guide your decisions.'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: 'At '),
                  TextSpan(
                    text: 'SmartLand',
                    style: TextStyle(color: Color(0xFF2E7D32),),
                  ),
                  TextSpan(
                      text:
                          ', we’re committed to empowering individuals, businesses, and investors with smart land analysis. Our mission is to simplify the decision-making process by using AI-driven insights to evaluate land suitability. We aim to make land assessment fast, reliable, and accessible to everyone.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}