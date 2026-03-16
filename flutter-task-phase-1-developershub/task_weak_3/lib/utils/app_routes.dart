import 'package:flutter/widgets.dart';
import 'package:task_weak_3/screens/auth/login_screen.dart';
import 'package:task_weak_3/screens/auth/register_screen.dart';
import 'package:task_weak_3/screens/home_screen.dart';
import 'package:task_weak_3/screens/splash_screen.dart';

class AppRoutes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String homeRoute = "/home";

  static Map<String, WidgetBuilder> routes = {
    splashRoute: (_) => SplashScreen(),
    loginRoute: (_) => LoginScreen(),
    registerRoute: (_) => RegisterScreen(),
    homeRoute: (_) => HomeScreen(),

  };
}
