import 'package:flutter/material.dart';

class OptionPage1 extends StatefulWidget {
  const OptionPage1({super.key});

  @override
  State<OptionPage1> createState() => _OptionPage1State();
}

class _OptionPage1State extends State<OptionPage1>
    with SingleTickerProviderStateMixin {
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

  // For animation
  double _dragDx = 0.0;
  bool _isDragging = false;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDx += details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragDx > 100) {
      // Swiped right, move top card to bottom
      setState(() {
        final card = cards.removeAt(0);
        cards.add(card);
        _dragDx = 0.0;
        _isDragging = false;
      });
    } else if (_dragDx < -100) {
      // Swiped left, move top card to bottom (optional, or keep as is)
      setState(() {
        final card = cards.removeAt(0);
        cards.add(card);
        _dragDx = 0.0;
        _isDragging = false;
      });
    } else {
      // Not enough drag, reset
      setState(() {
        _dragDx = 0.0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Stacked cards
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(cards.length, (i) {
                  // Top card is draggable
                  if (i == 0) {
                    return Positioned(
                      top: 20.0 * i,
                      child: GestureDetector(
                        onHorizontalDragStart: (_) {
                          setState(() {
                            _isDragging = true;
                          });
                        },
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                        child: Transform.translate(
                          offset: Offset(_isDragging ? _dragDx : 0, 0),
                          child: _buildCard(cards[i], scale: 1.0, elevation: 8),
                        ),
                      ),
                    );
                  }
                  // Second card
                  else if (i == 1) {
                    return Positioned(
                      top: 20.0 * i,
                      child: Transform.scale(
                        scale: 0.96,
                        child: _buildCard(cards[i], scale: 0.96, elevation: 4),
                      ),
                    );
                  }
                  // Third card
                  else {
                    return Positioned(
                      top: 20.0 * i,
                      child: Transform.scale(
                        scale: 0.92,
                        child: _buildCard(cards[i], scale: 0.92, elevation: 2),
                      ),
                    );
                  }
                }).reversed.toList(),
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

  Widget _buildCard(
    Map<String, dynamic> card, {
    double scale = 1.0,
    double elevation = 2,
  }) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 270 * scale,
        height: 150 * scale,
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
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        icon,
                        width: 32 * scale,
                        height: 32 * scale,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              card['title'],
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                card['desc'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12 * scale,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
