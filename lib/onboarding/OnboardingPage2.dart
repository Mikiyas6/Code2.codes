import 'package:flutter/material.dart';
import 'OnboardingPage3.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

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
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement skip logic
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 14,
                      fontWeight: FontWeight.w600, // semibold
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Illustration
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/onboarding2.png', // Place your illustration here
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Your Personalized DSA Journey\nStarts Here',
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
                'No more endless scrolling through random problems.\nWe build your learning path.',
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
                  // Progress dots (first is active)
                  Row(
                    children: [
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
                          builder: (context) => const OnboardingPage3(),
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
