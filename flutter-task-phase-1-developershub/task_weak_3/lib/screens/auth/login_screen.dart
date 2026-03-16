import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_weak_3/providers/login_provider.dart';
import 'package:task_weak_3/utils/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context);

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
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Email Field
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: authProvider.usernameController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(38),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.white.withAlpha(64),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Password Field
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: authProvider.passwordController,
                      obscureText: authProvider.obscureText,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            authProvider.toggleObscure();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(38),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.white.withAlpha(64),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Remember Row
                  Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.white,
                            checkColor: const Color(0xff2563EB),
                            value: authProvider.isremeber,
                            onChanged: (value) {
                              authProvider.toggleIsReme();
                            },
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        // authProvider.adminLogin(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xff2563EB),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xff2563EB),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Color(0xff2563EB),
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Signup Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text(
                        "Dont have an Account",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.registerRoute),
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Divider
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          color: Colors.white38,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white38,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Social Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.facebook_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.g_mobiledata_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
