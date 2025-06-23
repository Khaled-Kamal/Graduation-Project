import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smart_land/Screens/AuthScreen.dart';

class PasswordChangedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   centerTitle: true,
      //   title: FadeInDown(
      //     duration: Duration(milliseconds: 800),
      //     child: const Text(
      //       "Logoipsum",
      //       style: TextStyle(
      //         fontSize: 24,
      //         fontWeight: FontWeight.bold,
      //         color: Color(0xFF2E7D32),
      //       ),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: Duration(milliseconds: 900),
              child: Icon(
                Icons.check_circle,
                color: Color(0xFF2E7D32),
                size: 120,
              ),
            ),
            SizedBox(height: 20),
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: Text(
                "Your password has been changed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 40),
            SlideInUp(
              duration: Duration(milliseconds: 700),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  child: Text(
                    "Back To Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
