import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ChosenPage.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage>
    with SingleTickerProviderStateMixin {
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
  double _dragDy = 0.0;
  double _dragScale = 1.0;
  double _dragAngle = 0.0;
  double _dragOpacity = 1.0;
  bool _isDragging = false;
  bool _isOnboarding = true;

  late AnimationController _animationController;
  late Animation<double> _dragAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _setupOnboardingAnimation();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (_isOnboarding) _animationController.forward();
    });
  }

  void _setupOnboardingAnimation() {
    _dragAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController)
          ..addListener(() {
            final t = _dragAnimation.value;
            setState(() {
              _dragDx = 250 * t;
              _dragDy = -30 * t;
              _dragScale = 1.0 - 0.15 * t;
              _dragAngle = 0.1 * t;
              _dragOpacity = 1.0 - 0.8 * t;
            });
          })
          ..addStatusListener((status) async {
            if (!_isOnboarding) return;
            if (status == AnimationStatus.completed) {
              setState(() {
                final card = cards.removeAt(0);
                cards.add(card);
                _dragDx = _dragDy = 0.0;
                _dragScale = _dragOpacity = 1.0;
                _dragAngle = 0.0;
              });
              await Future.delayed(const Duration(milliseconds: 400));
              if (_isOnboarding) {
                _animationController.reset();
                _animationController.forward();
              }
            }
          });
  }

  void _stopOnboarding() {
    if (_isOnboarding) {
      setState(() {
        _isOnboarding = false;
        _animationController.stop();
        _dragDx = 0.0;
      });
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _stopOnboarding();
    setState(() {
      _dragDx += details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    _stopOnboarding();
    if (_dragDx.abs() > 100) {
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

  Future<void> _chooseCard(Map<String, dynamic> card) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final chosenCard = {
      'icons': card['icons'],
      'title': card['title'],
      'desc': card['desc'],
      'gradientColors': (card['gradient'] as LinearGradient).colors
          .map((c) => c.value)
          .toList(),
    };

    try {
      final response = await supabase
          .from('profiles')
          .update({'chosenCard': chosenCard})
          .eq('id', user.id)
          .select();

      print('✅ Update response: $response');

      if (response.isEmpty) {
        throw Exception(
          'No rows were updated. Check if the user exists or RLS is preventing updates.',
        );
      }

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ChosenPage()),
              );
            });
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save card: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('❌ Error saving chosen card to Supabase: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) => _stopOnboarding(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(cards.length, (i) {
                      final angles = [0.0, -0.28, 0.28];
                      if (i == 0) {
                        return Positioned(
                          child: GestureDetector(
                            onTapUp: (details) async {
                              _stopOnboarding();
                              // Only treat it as a tap if the drag movement was small
                              if (_dragDx.abs() < 10) {
                                await _chooseCard(cards[0]);
                              }
                            },
                            onHorizontalDragStart: (_) {
                              _stopOnboarding();
                              setState(() => _isDragging = true);
                            },
                            onHorizontalDragUpdate: _onDragUpdate,
                            onHorizontalDragEnd: _onDragEnd,
                            child: AnimatedOpacity(
                              opacity: _isOnboarding ? _dragOpacity : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Transform.translate(
                                offset: Offset(
                                  _isDragging || _isOnboarding ? _dragDx : 0,
                                  _isOnboarding ? _dragDy : 0,
                                ),
                                child: Transform.rotate(
                                  angle: _isOnboarding ? _dragAngle : 0,
                                  child: Transform.scale(
                                    scale: _isOnboarding ? _dragScale : 1.0,
                                    child: _buildCard(
                                      cards[i],
                                      scale: 1.0,
                                      elevation: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
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
                const SizedBox(height: 32),
                if (_isOnboarding)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Swipe to the right',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal[700],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.teal),
                    ],
                  ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 40),
              ],
            ),
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
    final isSingleImage = (card['icons'] as List).length == 1;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 270 * scale,
        height: 200 * scale,
        decoration: BoxDecoration(
          gradient: card['gradient'],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isSingleImage)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (card['icons'] as List<String>)
                    .map(
                      (icon) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Image.asset(
                          icon,
                          width: 32 * scale,
                          height: 32 * scale,
                        ),
                      ),
                    )
                    .toList(),
              ),
            if (isSingleImage)
              Image.asset(
                card['icons'][0],
                width: 90 * scale,
                height: 90 * scale,
              ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 12),
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
