// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/homepage.dart';
import 'package:sqlite_flutter_crud/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(), // Automatically redirects user
    );
  }
}

// 🔒 Widget that checks if user is logged in
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current user from FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;

    // If user is logged in, show homepage, else login screen
    return user != null ? HomeScreen() : LoginScreen();
  }
}
