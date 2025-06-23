import 'package:flutter/material.dart';
import 'package:smart_land/Pages/home_screen.dart';
import 'package:smart_land/Screens/AuthScreen.dart';

class HomeSelectionPage extends StatefulWidget {
  const HomeSelectionPage({super.key});

  @override
  _HomeSelectionPageState createState() => _HomeSelectionPageState();
}

class _HomeSelectionPageState extends State<HomeSelectionPage> {
  String? selectedRole;

  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _enterApp() {
    if (selectedRole != null) {
      if (selectedRole == 'guest') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (selectedRole == 'register') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a role before continuing')),
      );
    }
  }

  Widget _buildOption(String role, String imageAsset, String label) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () => _selectRole(role),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green[100] : Colors.white,
              border: Border.all(
                color: isSelected ? Color(0xFF2E7D32) : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imageAsset, width: 56, height: 56),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Image.asset('assets/logo.png', height: 130),
              SizedBox(height: 12),
              Text(
                'Welcome to SmartFarm',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                'Continue as a guest or sign in to access your\nsaved data and personalized tools.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                      'register', 'assets/login.png', 'Sign In or Register'),
                  _buildOption('guest', 'assets/guest.png', 'Guest'),
                ],
              ),
              SizedBox(height: 300),
              ElevatedButton(
                onPressed: _enterApp,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: Text('Enter App', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
