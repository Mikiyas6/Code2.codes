import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:code2codes/screens/wrapper.dart'; // ✅ Make sure this import is added
import 'package:code2codes/auth/presentation/sign_in.dart';
import 'package:code2codes/auth/presentation/sign_up.dart';
import 'package:code2codes/screens/home/home.dart'; // Import HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/home': (context) =>
            const Home(), // Replace with your actual home screen
        // Add other routes as needed
      },
      home: Wrapper(),
    );
  }
}
