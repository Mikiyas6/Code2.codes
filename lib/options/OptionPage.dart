import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChosenPage.dart';

class Optionpage extends StatefulWidget {
  const Optionpage({super.key});

  @override
  State<Optionpage> createState() => _OptionpageState();
}

class _OptionpageState extends State<Optionpage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> cards = [
    {
      // 1st card: 14B8A6 to 10B981
      'gradient': const LinearGradient(
        colors: [Color(0xFF14B8A6), Color(0xFF10B981)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
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
      // 2nd card: 60A5FA to A78BFA
      'gradient': const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFFA78BFA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'icons': ['assets/second_card.jpeg'],
      'title': 'Question Guided Path',
      'desc': 'Solve 1 Easy Linked List Question\n(Est. 5 mins)',
    },
    {
      // 3rd card: FDE68A to 166534
      'gradient': const LinearGradient(
        colors: [Color(0xFFFDE68A), Color(0xFF166534)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'icons': ['assets/third_card.jpeg'],
      'title': 'Foundational DSA Path',
      'desc':
          'Build A Solid Foundation. \nMaster DSA Topics From The Ground Up.',
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Stacked cards
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(cards.length, (i) {
                    // Increase tilt for back cards
                    final angles = [
                      0.0,
                      -0.28,
                      0.28,
                    ]; // More tilt for back cards
                    if (i == 0) {
                      // Top card: not rotated, draggable
                      return Positioned(
                        child: GestureDetector(
                          onTap: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final card = cards[0];
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set({
                                    'chosenCard': {
                                      'icons': card['icons'],
                                      'title': card['title'],
                                      'desc': card['desc'],
                                      'gradientColors':
                                          (card['gradient'] as LinearGradient)
                                              .colors
                                              .map((c) => c.value)
                                              .toList(),
                                    },
                                  }, SetOptions(merge: true));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChosenPage(),
                                ),
                              );
                            }
                          },
                          onHorizontalDragStart: (_) {
                            setState(() {
                              _isDragging = true;
                            });
                          },
                          onHorizontalDragUpdate: _onDragUpdate,
                          onHorizontalDragEnd: _onDragEnd,
                          child: Transform.translate(
                            offset: Offset(_isDragging ? _dragDx : 0, 0),
                            child: _buildCard(
                              cards[i],
                              scale: 1.0,
                              elevation: 8,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Back cards: more rotated and scaled
                      return Positioned(
                        child: Transform.rotate(
                          angle: angles[i],
                          child: Transform.scale(
                            scale: i == 1 ? 0.96 : 0.92,
                            child: _buildCard(
                              cards[i],
                              scale: i == 1 ? 0.96 : 0.92,
                              elevation: i == 1 ? 4 : 2,
                            ),
                          ),
                        ),
                      );
                    }
                  }).reversed.toList(),
                ),
              ),
              const SizedBox(height: 70),
              const Text(
                'You can Choose Any Path You Would\nLike To Pursue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    Map<String, dynamic> card, {
    double scale = 1.0,
    double elevation = 2,
  }) {
    // If only one icon, use the alternate layout
    final isSingleImage = (card['icons'] as List).length == 1;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 270 * scale,
        height: 200 * scale,
        decoration: BoxDecoration(
          gradient: card['gradient'], // Use gradient instead of color
          borderRadius: BorderRadius.circular(30),
        ),
        child: isSingleImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    card['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16), // Increased spacing
                  // Bigger centered image
                  Image.asset(
                    card['icons'][0],
                    width: 90 * scale, // Increased size
                    height: 90 * scale, // Increased size
                  ),
                  const SizedBox(height: 16), // Increased spacing
                  // Description
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<String>.from(card['icons'] as List)
                        .map(
                          (icon) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
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
                  // Title
                  Text(
                    card['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Description
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
