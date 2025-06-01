import 'package:flutter/material.dart';

class OptionPage1 extends StatefulWidget {
  const OptionPage1({super.key});

  @override
  State<OptionPage1> createState() => _OptionPage1State();
}

class _OptionPage1State extends State<OptionPage1> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> cards = [
    {
      'color': Colors.green.shade400,
      'icons': [
        'assets/facebook.png',
        'assets/apple.png',
        'assets/amazon.png',
        'assets/google.png',
      ],
      'title': 'Target Your Dream Job',
      'desc':
          'Select a specific tech company, and we will provide a curated learning path based on DSA topics and questions frequently asked in MAANG Interviews',
    },
    {
      'color': Colors.purple.shade400,
      'icons': [
        'assets/google.png',
        'assets/amazon.png',
        'assets/apple.png',
        'assets/facebook.png',
      ],
      'title': 'Master DSA Concepts',
      'desc':
          'Sharpen your skills with handpicked DSA problems and ace your coding interviews with confidence.',
    },
    {
      'color': Colors.orange.shade400,
      'icons': [
        'assets/amazon.png',
        'assets/facebook.png',
        'assets/apple.png',
        'assets/google.png',
      ],
      'title': 'Practice Real Interview Qs',
      'desc':
          'Practice with real interview questions asked by top tech companies and get detailed solutions.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Swipable cards
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO: Handle card selection
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 40,
                          child: Container(
                            width: 230,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          child: Container(
                            width: 250,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Container(
                          width: 270,
                          height: 150,
                          decoration: BoxDecoration(
                            color: card['color'],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: (card['icons'] as List<String>)
                                    .map(
                                      (icon) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Image.asset(
                                          icon,
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                card['title'],
                                style: const TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  card['desc'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cards.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF0961F5)
                        : Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'You can Choose Any Path You Would\nLike To Pursue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
