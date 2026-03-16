// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  bool obscurePassword = true;
  bool obscureConfirm = true;

  bool isLoading = false;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  bool formValidate() {

    emailError = "";
    passwordError = "";
    confirmPasswordError = "";

    bool isValid = true;

    if (emailController.text.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = "Confirm password required";
      isValid = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError = "Passwords do not match";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> register(BuildContext context) async {

    if (!formValidate()) return;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Register Successful"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}