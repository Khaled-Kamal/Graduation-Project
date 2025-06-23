import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final Dio _dio = Dio();
  String? _responseMessage;

  Future<void> _sendContactForm() async {
    try {
      final response = await _dio.post(
        'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Contact',
        data: {
          "name": nameController.text,
          "email": emailController.text,
          "phone": "+20 ${phoneController.text}", // Combine country code with phone
          "message": messageController.text,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = response.data['message'];
        });
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        messageController.clear();
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Failed to send message. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Logoipsum",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text("Name"),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Email"),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Phone"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: "+20",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "+20", child: Text("+20")),
                      DropdownMenuItem(value: "+1", child: Text("+1")),
                      DropdownMenuItem(value: "+44", child: Text("+44")),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: "Enter your phone",
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("Send a message"),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 30),

            if (_responseMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _responseMessage!,
                  style: const TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFF2E7D32),
                ),
                onPressed: _sendContactForm,
                child: const Text("Send", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}