import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userName = "Mike";

  // Card data (copied from OptionPage)
  final List<Map<String, dynamic>> cards = [
    {
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

  double _dragDx = 0.0;
  bool _isDragging = false;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDx += details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragDx.abs() > 100) {
      // Move top card to back
      setState(() {
        final card = cards.removeAt(0);
        cards.add(card);
        _dragDx = 0.0;
        _isDragging = false;
      });
    } else {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 239, 251),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, $userName👋",
                            style: const TextStyle(
                              fontFamily: 'Jost',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Good to see you back.",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 203, 205, 212),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications,
                                size: 28, // Make notification icon larger
                                color: Colors.white,
                              ),
                            ),
                            // Blue dot indicator
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Profile image as big as notification icon
                        CircleAvatar(
                          radius:
                              18, // Same as notification icon's outer radius
                          backgroundColor: Colors.grey[300],
                          backgroundImage: const AssetImage(
                            'assets/profile.jpg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Stats Row
              Row(
                children: [
                  _iconStat(Icons.favorite, "5", Colors.red),
                  const SizedBox(width: 12),
                  _iconStat(Icons.monetization_on, "7118", Colors.amber),
                  const SizedBox(width: 12),
                  _iconStat(Icons.local_fire_department, "7", Colors.orange),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black54),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Title
              const Text(
                "Let's See What We Have",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const Text(
                "For Today!",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              // Stacked, draggable cards
              Center(
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(cards.length, (i) {
                      // Tilt for back cards
                      final angles = [0.0, 0.18, -0.28];
                      if (i == 0) {
                        // Top card: draggable
                        return Positioned(
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
                              child: _optionCard(
                                gradient: cards[i]['gradient'],
                                icons: List<String>.from(
                                  cards[i]['icons'] as List,
                                ),
                                title: cards[i]['title'],
                                desc: cards[i]['desc'],
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Back cards: tilted and scaled
                        return Positioned(
                          child: Transform.rotate(
                            angle: angles[i],
                            child: Transform.scale(
                              scale: i == 1 ? 0.96 : 0.92,
                              child: _optionCard(
                                gradient: cards[i]['gradient'],
                                icons: List<String>.from(
                                  cards[i]['icons'] as List,
                                ),
                                title: cards[i]['title'],
                                desc: cards[i]['desc'],
                              ),
                            ),
                          ),
                        );
                      }
                    }).reversed.toList(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Recent learning",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Recent learning cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _learningCard(
                      image: 'assets/tree.jpg', // <-- Use your image asset
                      title: "Trees Overview",
                      subtitle: "Everything You need to know about Trees",
                      progress: 5 / 12,
                    ),
                    const SizedBox(width: 12),
                    _learningCard(
                      image: 'assets/recursion.jpg', // <-- Use your image asset
                      title: "Recursion",
                      subtitle: "A deep dive into the world of Recursion",
                      progress: 2 / 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fitness_center,
            ), // Changed from play_arrow to dumbbell
            label: "Practice",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Leaderboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _iconStat(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _learningCard({
    required String image,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional image display
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1.4, // Nice card aspect
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE3E8F0),
              color: const Color(0xFF6366F1),
              minHeight: 8,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required LinearGradient gradient,
    required List<String> icons,
    required String title,
    required String desc,
  }) {
    final isSingleImage = icons.length == 1;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 260,
        height: 200,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isSingleImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(icons[0], width: 90, height: 90),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: icons
                        .map(
                          (icon) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Image.asset(icon, width: 32, height: 32),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      desc,
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
    );
  }
}
