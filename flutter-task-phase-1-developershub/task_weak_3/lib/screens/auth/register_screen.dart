import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_weak_3/providers/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff2563EB),
              Color(0xff3B82F6),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Email
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: registerProvider.emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.email,color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withAlpha(38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Password
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: registerProvider.passwordController,
                      obscureText: registerProvider.obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock,color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            registerProvider.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: registerProvider.togglePassword,
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Confirm Password
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: registerProvider.confirmPasswordController,
                      obscureText: registerProvider.obscureConfirm,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock_outline,color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            registerProvider.obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: registerProvider.toggleConfirm,
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        registerProvider.register(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: registerProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : const Text(
                              "Register",
                              style: TextStyle(
                                color: Color(0xff2563EB),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Back to Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}