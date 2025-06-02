import 'package:flutter/material.dart';
import 'package:code2codes/screens/home/home.dart';

class ProgressScreen extends StatefulWidget {
  final Map<String, dynamic> chosenCard;
  const ProgressScreen({super.key, required this.chosenCard});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildConfetti() {
    // Simple confetti effect using positioned colored circles
    return Stack(
      children: List.generate(30, (i) {
        final random = i * 37 % 255;
        return Positioned(
          left: (i * 23) % 320 + 10,
          top: (i * 53) % 500 + 10,
          child: Container(
            width: 8 + (i % 3) * 4.0,
            height: 8 + (i % 3) * 4.0,
            decoration: BoxDecoration(
              color: Color.fromARGB(
                255,
                (random + 50) % 255,
                (random + 120) % 255,
                (random + 200) % 255,
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Stack(
        children: [
          _buildConfetti(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gradient ring progress
                  AnimatedBuilder(
                    animation: _progressAnim,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _GradientProgressPainter(_progressAnim.value),
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: Center(
                            child: Icon(
                              Icons.emoji_events_rounded,
                              color: Colors.amber.shade700,
                              size: 70,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    "You're All Set!",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0961F5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your personalized journey is ready.\nLet's make progress together 🚀",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0961F5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: Colors.tealAccent,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(chosenCard: widget.chosenCard),
                          ),
                        );
                      },
                      label: const Text(
                        "Start",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  final double progress;
  _GradientProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      startAngle: -1.57,
      endAngle: 4.71,
      colors: const [
        Color(0xFF14B8A6),
        Color(0xFF10B981),
        Color(0xFF60A5FA),
        Color(0xFFA78BFA),
        Color(0xFFFDE68A),
        Color(0xFF166534),
        Color(0xFF14B8A6),
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 0.95, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 12;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      6.28 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
