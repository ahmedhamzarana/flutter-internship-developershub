import 'package:flutter/material.dart';
import 'package:task_1/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void formValidate() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  bool isObscure = true;
  bool isremember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5],
            colors: [Colors.orange.shade900, Colors.black],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                /// Email
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: emailController,
                    cursorColor: Colors.white30,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(30),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withAlpha(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withAlpha(30),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Password
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: passwordController,
                    cursorColor: Colors.white30,
                    obscureText: isObscure,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(30),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withAlpha(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withAlpha(30),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.orange.shade900,
                          checkColor: Colors.white,
                          value: isremember,
                          onChanged: (value) => setState(() {
                            isremember = !isremember;
                          }),
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: formValidate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900.withAlpha(220),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white30, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white30, thickness: 1),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.facebook_outlined,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10), // 👈 10px space

                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.g_mobiledata_outlined,
                          color: Colors.white,
                          size: 30,
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
    );
  }
}
