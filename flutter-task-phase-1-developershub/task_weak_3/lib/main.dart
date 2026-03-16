import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_weak_3/firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'utils/app_routes.dart';
import 'utils/constants.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        // AuthProvider - Manages authentication state
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        // TaskProvider - Manages tasks state
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// MyApp - Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme configuration
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          
          // AppBar theme
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          
          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          
          // Elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
          
          // Card theme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
          ),
          
          // Floating action button theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 4,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        
        // Routes configuration
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings),
      );
  }
}
