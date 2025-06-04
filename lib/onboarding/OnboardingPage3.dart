import 'package:code2codes/auth/presentation/sign_up.dart';
import 'package:flutter/material.dart';
import 'OnboardingPage4.dart';
import '../auth/presentation/sign_up.dart'; // <-- Import your sign up page

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row: Back and Skip buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Skip button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Illustration (G logo)
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/onboarding3.png', // Place your G logo here
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Train for Top Tech Interviews,\nThe Right Way',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  fontWeight: FontWeight.w600, // semibold
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              // Subtitle
              const Text(
                'From FAANG-style questions to guided problem breakdowns, we have everything you need.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Progress indicator and next button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress dots (second is active)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Active indicator: small rounded rectangle
                      Container(
                        width: 15,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0961F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  // Next button
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingPage4(),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFF0961F5),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
