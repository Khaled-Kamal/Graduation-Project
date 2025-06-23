import 'package:flutter/material.dart';
import 'package:smart_land/Screens/create_new_password.dart';
import 'package:smart_land/services/resetcodeApi.dart';

class ResetCodePage extends StatefulWidget {
  final String email; 
  final String token; 

  const ResetCodePage({super.key, required this.email, required this.token});

  @override
  State<ResetCodePage> createState() => _ResetCodePageState();
}

class _ResetCodePageState extends State<ResetCodePage> {
  List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  List<ValueNotifier<bool>> isEmpty = List.generate(
    4,
    (_) => ValueNotifier<bool>(true),
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      controllers[i].addListener(() {
        isEmpty[i].value = controllers[i].text.isEmpty;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/logo.png', width: 111),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            const Text(
              "Reset Code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            const Text(
              "We have sent a verification code to your email. Please check and enter the code below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return ValueListenableBuilder<bool>(
                  valueListenable: isEmpty[index],
                  builder: (context, empty, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 1.5),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: TextField(
                            controller: controllers[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                isEmpty[index].value = false;
                                if (index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              } else {
                                isEmpty[index].value = true;
                              }
                            },
                          ),
                        ),
                        if (empty)
                          Positioned(
                            child: Container(
                              width: 40,
                              height: 2,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            const Text(
              "Didn't receive the code?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Click here to ",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Re-sending code...")),
                    );
                  },
                  child: const Text(
                    "Re-send code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF2E7D32),
                      decorationThickness: 2.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  String code = controllers.map((e) => e.text).join();

                  final result = await VerifyCodeService.verifyCode(
                    email: widget.email,
                    code: code,
                    token: widget.token,
                  );

                  if (result == "Code verified successfully.") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNewPasswordPage(token: widget.token)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  }
                },
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
