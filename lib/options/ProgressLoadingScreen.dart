import 'package:code2codes/options/ProgressScreen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ProgressLoadingScreen extends StatefulWidget {
  const ProgressLoadingScreen({super.key});

  @override
  State<ProgressLoadingScreen> createState() => _ProgressLoadingScreenState();
}

class _ProgressLoadingScreenState extends State<ProgressLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(
      begin: 0,
      end: -28,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Show loading for 5 seconds, then navigate to ProgressScreen
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProgressScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPlayfulAnimation() {
    // Bouncing smiley, confetti, and playful cards
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti dots in a perfect circle using trigonometry
          ...List.generate(18, (i) {
            final angle = (i / 18) * 2 * 3.1415926;
            final radius = 75.0;
            return Positioned(
              left: 90 + radius * cos(angle),
              top: 90 + radius * sin(angle),
              child: Container(
                width: 12 + (i % 3) * 4.0,
                height: 12 + (i % 3) * 4.0,
                decoration: BoxDecoration(
                  color: [
                    Colors.amber,
                    Colors.blueAccent,
                    Colors.pinkAccent,
                    Colors.greenAccent,
                    Colors.purpleAccent,
                    Colors.orangeAccent,
                  ][i % 6].withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          // Playful bouncing smiley
          AnimatedBuilder(
            animation: _bounceAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnim.value),
                child: child,
              );
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(child: Text("😃", style: TextStyle(fontSize: 56))),
            ),
          ),
          // Playful cards floating around
          ...List.generate(3, (i) {
            final cardIcons = [
              Icons.rocket_launch,
              Icons.auto_awesome,
              Icons.star,
            ];
            final angles = [0.5, -0.7, 1.2];
            final offsets = [
              Offset(-60, -60),
              Offset(70, -40),
              Offset(-40, 70),
            ];
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset:
                      offsets[i] +
                      Offset(
                        8 * (_controller.value - 0.5),
                        8 * (_controller.value - 0.5),
                      ),
                  child: Transform.rotate(
                    angle: angles[i] + (_controller.value * 1.5),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent.shade100, Colors.amber.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.15),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(cardIcons[i], color: Colors.white, size: 28),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExcitingAnimation() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated confetti dots in a circle
          ...List.generate(18, (i) {
            final angle = (i / 18) * 2 * pi + (_controller.value * 2 * pi);
            final radius = 80.0 + 8 * sin(_controller.value * 2 * pi + i);
            return Positioned(
              left: 100 + radius * cos(angle),
              top: 100 + radius * sin(angle),
              child: Container(
                width: 10 + (i % 3) * 4.0,
                height: 10 + (i % 3) * 4.0,
                decoration: BoxDecoration(
                  color: [
                    Colors.amber,
                    Colors.blueAccent,
                    Colors.pinkAccent,
                    Colors.greenAccent,
                    Colors.purpleAccent,
                    Colors.orangeAccent,
                  ][i % 6].withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          // Sparkles
          ...List.generate(4, (i) {
            final sparkleAngle = (_controller.value + i / 4) * 2 * pi;
            final sparkleRadius =
                55.0 + 10 * sin(_controller.value * 2 * pi + i);
            return Positioned(
              left: 100 + sparkleRadius * cos(sparkleAngle),
              top: 100 + sparkleRadius * sin(sparkleAngle),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.amberAccent.withOpacity(0.7),
                size: 22 + 6 * sin(_controller.value * 2 * pi + i),
              ),
            );
          }),
          // Rocket launch animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Rocket bounces up and down, then "launches" at the end
              double t = _controller.value;
              double bounce = -40 * (1 - pow(1 - t, 2).toDouble());
              double launch = t > 0.8 ? -300 * (t - 0.8) * 5 : 0;
              return Transform.translate(
                offset: Offset(0, bounce + launch),
                child: child,
              );
            },
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.rocket_launch, color: Colors.white, size: 54),
              ),
            ),
          ),
          // Happy face at the bottom, waves hello
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double t = _controller.value;
              double wave = 10 * sin(t * 2 * pi);
              return Positioned(
                bottom: 18 + wave,
                left: 100 - 28,
                child: Text(
                  "👋😃",
                  style: TextStyle(fontSize: 36 + 2 * sin(t * 2 * pi)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEducationalAnimation() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated orbiting icons (book, lightbulb, code, school)
          ...List.generate(4, (i) {
            final icons = [
              Icons.menu_book_rounded,
              Icons.lightbulb_outline,
              Icons.code,
              Icons.school,
            ];
            final colors = [
              Colors.blueAccent,
              Colors.amber,
              Colors.green,
              Colors.deepPurple,
            ];
            final angle = (_controller.value + i / 4) * 2 * pi;
            final radius = 70.0;
            return Positioned(
              left: 100 + radius * cos(angle) - 24,
              top: 100 + radius * sin(angle) - 24,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors[i].withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icons[i], color: colors[i], size: 32),
              ),
            );
          }),
          // Center animated glowing circle (focus/knowledge)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double glow = 8 + 8 * sin(_controller.value * 2 * pi);
              return Container(
                width: 90 + glow,
                height: 90 + glow,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF60A5FA), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(
                        0.25 + 0.25 * _controller.value,
                      ),
                      blurRadius: 32 + glow,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEducationalAnimation(),
            const SizedBox(height: 32),
            const Text(
              "Wait for a second while we curate your experience",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 42, 43, 43),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
