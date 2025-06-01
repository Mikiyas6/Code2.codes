import 'package:code2codes/onboarding/OnboardingPage2.dart';
import 'package:code2codes/options/OptionPage1.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either the Home or Authenticate widget
    return OnboardingPage2();
  }
}
