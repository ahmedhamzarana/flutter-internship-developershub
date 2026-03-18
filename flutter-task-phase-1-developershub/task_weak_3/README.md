# Task Manager - Flutter + Firebase + Provider

A complete, production-ready Flutter task management application with Firebase backend, Provider state management, and secure local storage. Built with best practices for scalability and maintainability.

## Features

### Authentication
- User Registration with email/password
- User Login with email/password
- Password Reset functionality
- Secure session persistence using Flutter Secure Storage
- Auto-login on app restart
- Logout functionality

### Task Management
- Add new tasks with title, description, date and time
- Edit existing tasks
- Delete tasks with confirmation
- Mark tasks as complete, pending, or in-progress
- Task priority levels: Low, Medium, High
- Task status tracking
- Real-time task updates via Firebase
- Task filtering: All, Pending, In Progress, Completed, Overdue
- Task search functionality
- Overdue task detection
- Task statistics dashboard

### UI/UX
- Material Design 3 UI
- Responsive layouts
- Animated splash screen
- Loading states
- Error handling with user-friendly messages
- Empty states
- Success and Error snackbars
- Confirmation dialogs
- Custom reusable widgets
- Consistent theme and styling

## Project Structure

The project follows a clean architecture pattern:

- **main.dart** - App entry point with Firebase and Provider setup
- **firebase_options.dart** - Auto-generated Firebase configuration (exclude from version control)
- **models/** - Data models for User and Task entities
- **services/** - Firebase Authentication, Firestore, and Secure Storage services
- **providers/** - State management using Provider pattern
- **screens/** - All UI screens including auth, home, and task screens
- **widgets/** - Reusable UI components
- **components/** - Additional UI components
- **utils/** - App routes, form validators, and constants

## Prerequisites

Before getting started, ensure you have the following installed:

1. Flutter SDK (latest stable version)
2. Dart SDK
3. Android Studio or VS Code with Flutter extensions
4. Git for version control
5. A Google account for Firebase

## Setup Instructions

### Step 1: Clone and Install Dependencies

Clone the repository and navigate to the project directory. Run the Flutter package manager to install all dependencies.

### Step 2: Firebase Project Setup

1. Visit the Firebase Console website
2. Create a new Firebase project or select an existing one
3. Give your project a name and follow the setup wizard

### Step 3: Register Your App with Firebase

For Android:
- Register your Android app with your project's package name
- Download the configuration file for Android
- Place the configuration file in the Android app directory

For iOS:
- Register your iOS app with your project's bundle identifier
- Download the configuration file for iOS
- Place the configuration file in the iOS Runner directory

### Step 4: Enable Firebase Services

Firestore Database:
- Navigate to the Firestore section in Firebase Console
- Create a new database
- Choose test mode for development (update rules for production)
- Select your preferred location

Authentication:
- Navigate to the Authentication section
- Enable Email/Password sign-in method

### Step 5: Configure Firestore Security Rules

For production environments, configure security rules to ensure users can only access their own data. Set up rules for the users collection and tasks collection with appropriate read and write permissions.

### Step 6: Run the Application

Use the Flutter CLI to run the application on your preferred device or emulator.

### Step 7: Build for Production

Build APK for Android or IPA for iOS using the Flutter build commands with release mode.

## Security Features

1. **Secure Storage** - Uses Flutter Secure Storage for tokens and user data
2. **Firebase Auth** - Industry-standard authentication
3. **Firestore Rules** - User-specific data access control
4. **Password Validation** - Minimum character requirements
5. **Session Management** - Auto-logout on token expiration
6. **Form Validation** - Client-side validation for all inputs

## Testing

Run the test suite using the Flutter test command. For coverage reports, use the coverage flag.

## Screens Overview

| Screen | Description |
|--------|-------------|
| Splash Screen | Animated logo with authentication check |
| Login Screen | Email/password login with forgot password |
| Register Screen | New user registration with validation |
| Home Screen | Task list with filters, search, and statistics |
| Task Screen | Add/Edit task with date/time pickers and priority selector |

## Troubleshooting

### Firebase Initialization Error
- Ensure the configuration file is placed in the correct directory
- Verify the Firebase Services plugin is properly configured
- Clean and rebuild the project

### Build Errors
- Run clean command
- Reinstall dependencies
- Rebuild the project

### Authentication Error
- Verify Email/Password authentication is enabled in Firebase Console
- Check internet connectivity
- Confirm Firebase configuration is correct

### Firestore Permission Error
- Update Firestore security rules in Firebase Console
- Use test mode for development purposes

## Key Concepts

### Provider Pattern
Provider is a state management solution that uses InheritedWidget under the hood. It follows the observer pattern to notify widgets when data changes.

### Firebase Integration
Firebase provides backend services including authentication, real-time database, and cloud storage. The app uses Firebase Auth for user management and Firestore for data persistence.

### Secure Storage
Sensitive data like authentication tokens are stored using Flutter Secure Storage, which encrypts data on both Android and iOS platforms.

## Future Enhancements

- Task categories and tags
- Task attachments
- Push notifications
- Dark mode theme
- User profile editing
- Task comments and collaboration
- Task sharing
- Recurring tasks
- Task templates
- Analytics dashboard
- Offline support
- Cloud backup and sync

## Dependencies

The project uses the following main packages:
- Firebase Core, Firestore, and Auth for backend services
- Provider for state management
- Flutter Secure Storage for local secure storage
- UUID for unique ID generation
- Intl for date and time formatting

## License

This project is for educational purposes.

---

**Happy Coding!**
