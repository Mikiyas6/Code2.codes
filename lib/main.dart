import 'package:code2codes/auth/data/auth_service.dart';
import 'package:code2codes/options/ChosenPage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:code2codes/auth/presentation/sign_in.dart';
import 'package:code2codes/auth/presentation/sign_up.dart';
import 'package:code2codes/screens/home/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code2codes/options/OptionPage.dart';
import 'package:code2codes/onboarding/OnboardingPage2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://viihnnyjpjnphpyaeyyf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZpaWhubnlqcGpucGhweWFleXlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxMDg2OTksImV4cCI6MjA2NDY4NDY5OX0.IiHOfPSFJ7-7kDE6he5P_-nB41zjcJOwg8Viqub-u-w',
  );
  AuthService().setupAuthStateListener();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routes: {
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/options': (context) => const OptionPage(),
        '/chosen': (context) => const ChosenPage(),
      },
      home: OnboardingPage2(), // <-- Show onboarding every time
    );
  }
}
