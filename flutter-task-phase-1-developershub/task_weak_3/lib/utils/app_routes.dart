import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/task_screen.dart';
import '../models/task_model.dart';

/// AppRoutes - Centralized route management
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String task = '/task';

  // All routes
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      home: (_) => const HomeScreen(),
      task: (_) => const TaskScreen(),
    };
  }

  // Generate route settings for navigation with arguments
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      
      case task:
        // Extract arguments
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TaskScreen(
            taskId: args?['taskId'] as String?,
            existingTask: args?['existingTask'] as TaskModel?,
          ),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}

/// NavigationHelper - Helper class for navigation
class NavigationHelper {
  /// Navigate to login screen and clear stack
  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  /// Navigate to home screen and clear stack
  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  /// Navigate to register screen
  static void goToRegister(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.register,
    );
  }

  /// Navigate to task screen for adding new task
  static void goToAddTask(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.task,
      arguments: {'taskId': null, 'existingTask': null},
    );
  }

  /// Navigate to task screen for editing existing task
  static void goToEditTask(BuildContext context, TaskModel task) {
    Navigator.pushNamed(
      context,
      AppRoutes.task,
      arguments: {'taskId': task.id, 'existingTask': task},
    );
  }

  /// Navigate back
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigate back with result
  static void goBackWithResult<T>(BuildContext context, T result) {
    Navigator.pop(context, result);
  }
}
