import 'package:flutter/material.dart';


class TermsAndConditionsPage extends StatelessWidget {
  static const TextStyle headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static const TextStyle bulletStyle = TextStyle(
    fontSize: 14,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and conditions", style: TextStyle(color: Colors.black)),
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
            SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black , fontWeight: FontWeight.w600),
                children: [
                  TextSpan(text: 'Welcome to ' , style: TextStyle(fontSize: 20)),
                  TextSpan(
                    text: 'SmartLand' ,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue ,),
                  ),
                  TextSpan(
                      text:
                          '\nBy using our app, you agree to the following terms and conditions. Please read them carefully.'),
                ],
              ),
            ),
            SizedBox(height: 20),

            /// 1. Use of the App
            Text('1. Use of the App', style: headingStyle),
            SizedBox(height: 8),
            bulletPoint('SmartLand provides AI-based land analysis for informational purposes only.'),
            bulletPoint('Users must ensure the accuracy of the location entered before relying on results.'),

            SizedBox(height: 20),

            /// 2. Data Privacy
            Text('2. Data Privacy', style: headingStyle),
            SizedBox(height: 8),
            bulletPoint('We respect your privacy and do not share personal data without consent.'),
            bulletPoint('Location data is used solely for land analysis and is not stored permanently.'),

            SizedBox(height: 20),

            /// 3. Limitations of Liability
            Text('3. Limitations of Liability', style: headingStyle),
            SizedBox(height: 8),
            bulletPoint('SmartLand does not guarantee 100% accuracy in land suitability analysis.'),
            bulletPoint('We are not responsible for decisions made based on app recommendations.'),

            SizedBox(height: 20),

            /// 4. Updates & Changes
            Text('4. Updates & Changes', style: headingStyle),
            SizedBox(height: 8),
            bulletPoint('Terms may be updated occasionally, and continued use of the app means acceptance of the latest terms.'),
          ],
        ),
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: bulletStyle),
        Expanded(child: Text(text, style: bulletStyle)),
      ],
    );
  }
}