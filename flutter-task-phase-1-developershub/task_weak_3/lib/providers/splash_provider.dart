import 'package:flutter/material.dart';
import 'package:task_weak_3/utils/app_routes.dart';

class SplashProvider extends ChangeNotifier {
  void splashTimer(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context , AppRoutes.loginRoute),
    );
  }
}
