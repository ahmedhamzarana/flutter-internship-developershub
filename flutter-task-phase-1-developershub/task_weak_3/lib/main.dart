import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_weak_3/providers/login_provider.dart';
import 'package:task_weak_3/providers/register_provider.dart';
import 'package:task_weak_3/providers/splash_provider.dart';
import 'package:task_weak_3/utils/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_)=> RegisterProvider())
        ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splashRoute,
    );
  }
}
