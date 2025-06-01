import 'package:flutter/material.dart';
import '../auth/presentation/sign_up.dart'; // Make sure this path is correct

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

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
              const SizedBox(height: 60),
              // Illustration
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/onboarding4.png', // Place your illustration here
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Struggling? Busy? Starting Over?\nWe Got You.',
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
                'Whether you\'re busy, low on confidence, or maybe just starting out, we meet you where you are and help you grow from there',
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
                  // Progress dots (third is active and rectangular)
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
                    ],
                  ),
                  // Next button
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
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
