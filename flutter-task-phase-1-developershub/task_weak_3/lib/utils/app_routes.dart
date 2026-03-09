import 'package:flutter/widgets.dart';
import 'package:task_weak_3/screens/home_screen.dart';
import 'package:task_weak_3/screens/splash_screen.dart';

class AppRoutes {
  static const String splashRoute = "/";
  static const String homeRoute = "/home";

  static Map<String, WidgetBuilder> routes = {
    splashRoute: (_) => SplashScreen(),
    homeRoute: (_) => HomeScreen(),

  };
}
