# Task Manager - Flutter + Firebase + Provider

A complete, production-ready Flutter task management application with Firebase backend, Provider state management, and secure local storage. Built with best practices for scalability and maintainability.

## 🚀 Features

### Authentication
- ✅ User Registration with email/password
- ✅ User Login with email/password  
- ✅ Password Reset functionality
- ✅ Secure session persistence (Flutter Secure Storage)
- ✅ Auto-login on app restart
- ✅ Logout functionality

### Task Management
- ✅ Add new tasks with title, description, date & time
- ✅ Edit existing tasks
- ✅ Delete tasks with confirmation
- ✅ Mark tasks as complete/pending/in-progress
- ✅ Task priority levels (Low, Medium, High)
- ✅ Task status tracking
- ✅ Real-time task updates via Firebase
- ✅ Task filtering (All, Pending, In Progress, Completed, Overdue)
- ✅ Task search functionality
- ✅ Overdue task detection
- ✅ Task statistics dashboard

### UI/UX
- ✅ Material Design 3 UI
- ✅ Responsive layouts
- ✅ Animated splash screen
- ✅ Loading states
- ✅ Error handling with user-friendly messages
- ✅ Empty states
- ✅ Success/Error snackbars
- ✅ Confirmation dialogs
- ✅ Custom reusable widgets
- ✅ Consistent theme and styling

## 📁 Project Structure

```
lib/
├── main.dart                     # App entry point with Firebase & Provider setup
├── firebase_options.dart         # Auto-generated Firebase configuration
├── models/
│   ├── user_model.dart           # User data model with Firestore serialization
│   └── task_model.dart           # Task model with TaskPriority & TaskStatus enums
├── services/
│   ├── auth_service.dart         # Firebase Authentication service (singleton)
│   ├── task_service.dart         # Firebase Firestore service for tasks
│   └── storage_service.dart      # Flutter Secure Storage wrapper
├── providers/
│   ├── auth_provider.dart        # Authentication state management
│   ├── task_provider.dart        # Tasks state management with real-time updates
│   └── home_provider.dart        # Home screen state management
├── screens/
│   ├── splash_screen.dart        # Animated splash with auth check
│   ├── auth/
│   │   ├── login_screen.dart     # Login screen with form validation
│   │   └── register_screen.dart  # Registration screen
│   ├── home_screen.dart          # Main task list with filters & search
│   └── task_screen.dart          # Add/Edit task screen with date/time pickers
├── widgets/
│   ├── custom_button.dart        # Reusable button with variants
│   ├── custom_text_field.dart    # Reusable text field & dropdown
│   ├── task_card.dart            # Task card component
│   └── common_widgets.dart       # Loading, Empty, Error state widgets
├── components/
│   └── task_card.dart            # Alternative task card component
└── utils/
    ├── app_routes.dart           # Route configuration & navigation helper
    ├── validators.dart           # Form validation functions
    └── constants.dart            # App constants, colors, text styles, spacing
```

## 🛠️ Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^4.5.0           # Firebase initialization
  cloud_firestore: ^5.4.4         # Firestore database
  firebase_auth: ^6.2.0           # Firebase Authentication

  # State Management
  provider: ^6.1.4                # Provider pattern (ChangeNotifier)

  # Storage
  flutter_secure_storage: ^10.0.0 # Secure local storage

  # Utilities
  uuid: ^4.5.1                    # Unique ID generation
  intl: ^0.20.2                   # Date/time formatting
```

## 📋 Firebase Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name (e.g., "Task Manager")
4. Disable Google Analytics (optional)
5. Click **Create project**

### Step 2: Add Android App

1. Click **Android icon** to add Android app
2. Package name: `com.example.task_weak_3`
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

5. In `android/build.gradle`:
```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
  }
}
```

6. In `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Step 3: Add iOS App (Optional)

1. Click **iOS icon** to add iOS app
2. Bundle ID: `com.example.taskWeak3`
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Enable Firebase Services

#### Firestore Database
1. Go to **Build** → **Firestore Database**
2. Click **Create database**
3. Start in **test mode** (for development)
4. Choose location

#### Authentication
1. Go to **Build** → **Authentication**
2. Click **Get started**
3. Enable **Email/Password** provider

### Step 5: Firestore Security Rules

For production, use these rules in Firebase Console → Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Tasks collection
    match /tasks/{taskId} {
      allow read: if request.auth != null &&
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null &&
                       request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null &&
                               resource.data.userId == request.auth.uid;
    }
  }
}
```

## 🏃 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Build for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔐 Security Features

1. **Secure Storage**: Uses Flutter Secure Storage for tokens and user data
2. **Firebase Auth**: Industry-standard authentication
3. **Firestore Rules**: User-specific data access control
4. **Password Validation**: Minimum 6 characters with at least one letter
5. **Session Management**: Auto-logout on token expiration
6. **Form Validation**: Client-side validation for all inputs

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Screens

| Screen | Description |
|--------|-------------|
| Splash Screen | Animated logo with authentication check |
| Login Screen | Email/password login with forgot password |
| Register Screen | New user registration with validation |
| Home Screen | Task list with filters, search, and statistics |
| Task Screen | Add/Edit task with date/time pickers and priority selector |

## 🐛 Troubleshooting

### Firebase Initialization Error
```
Make sure google-services.json is in android/app/
Make sure Google Services plugin is applied
Run: flutter clean && flutter pub get
```

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### Auth Error
```
Make sure Email/Password is enabled in Firebase Console
Check internet connection
Verify firebase_options.dart is configured
```

### Firestore Permission Error
```
Update Firestore rules in Firebase Console
Use test mode for development
```

## 📝 Key Concepts

### Provider Pattern
Provider is a state management solution that uses InheritedWidget under the hood.

```dart
// Create provider
class MyProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// Provide it
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ],
  child: MyApp(),
)

// Consume it
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text('${provider.count}');
  },
)
```

### StatefulWidget Lifecycle
```dart
class _MyState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize data
  }

  @override
  void dispose() {
    // Clean up controllers, subscriptions
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Singleton Pattern (Services)
```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();
}
```

## 🚀 Future Enhancements

- [ ] Task categories/tags
- [ ] Task attachments
- [ ] Push notifications
- [ ] Dark mode theme
- [ ] User profile editing
- [ ] Task comments
- [ ] Task sharing
- [ ] Recurring tasks
- [ ] Task templates
- [ ] Analytics dashboard
- [ ] Offline support
- [ ] Cloud backup

## 📄 License

This project is for educational purposes.

## 👨‍💻 Author

Task Manager - Built with Flutter, Firebase, and Provider

---

**Happy Coding! 🎉**
