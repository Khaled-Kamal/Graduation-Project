import 'package:flutter/material.dart';
import 'package:smart_land/Screens/verification.dart';
import 'package:smart_land/services/newPasswoedAPI.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String token;

  const CreateNewPasswordPage({super.key, required this.token});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  bool showCriteriaWarning = false;

  void _validateAndProceed() async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      showCriteriaWarning = password.isNotEmpty && password.length < 8;
    });

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showMessage("Please fill in all fields");
      return;
    }

    if (password.length < 8) {
      return; // لا تظهر رسالة هنا، لأن التحذير يظهر تحت الحقل
    }

    if (password != confirmPassword) {
      _showMessage("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    final result = await ResetPasswordService.resetPassword(
      newPassword: password,
      confirmPassword: confirmPassword,
      token: widget.token,
    );

    setState(() => isLoading = false);

    if (result == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PasswordChangedPage()),
      );
    } else {
      _showMessage(result);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your new password must be different from previously used passwords.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                  "New Password", passwordController, isPasswordVisible, () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              }),
              const SizedBox(height: 8),
              if (showCriteriaWarning) _buildPasswordCriteria(),
              const SizedBox(height: 20),
              _buildPasswordField("Confirm Password", confirmPasswordController,
                  isConfirmPasswordVisible, () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _validateAndProceed,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          onChanged: (value) {
            if (label == "New Password") {
              setState(() {
                showCriteriaWarning = value.isNotEmpty && value.length < 8;
              });
            }
          },
          decoration: InputDecoration(
            hintText: label == "New Password"
                ? "Enter your password"
                : "Confirm your password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: toggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordCriteria() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: const [
          Icon(Icons.error_outline, color: Color(0xFFFFBC1F), size: 16),
          SizedBox(width: 6),
          Text(
            "Must be at least 8 characters",
            style: TextStyle(fontSize: 12, color: Color(0xFFFFBC1F)),
          ),
        ],
      ),
    );
  }
}
