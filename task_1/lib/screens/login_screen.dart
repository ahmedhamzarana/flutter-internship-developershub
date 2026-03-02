import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            colors: [
              Color(0xFFF25912),
              Colors.black,
            ],
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
                TextField(
                  cursorColor: Colors.white30,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: Colors.white.withAlpha(30), // 👈 here
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(width: 2,color: Colors.grey.withAlpha(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(width: 2,color: Colors.grey.withAlpha(30))
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13, // 👈 height control
                      horizontal: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Password
                TextField(
                  cursorColor: Colors.white30,
                  obscureText: isObscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white,
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
                      borderSide: BorderSide(width: 2,color: Colors.grey.withAlpha(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(width: 2,color: Colors.grey.withAlpha(30))
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13, 
                      horizontal: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Color(
                            0xFFF25912,
                          ),
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
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF25912).withAlpha(220),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
