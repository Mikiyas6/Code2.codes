import 'package:code2codes/options/ProgressLoadingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChosenPage extends StatelessWidget {
  const ChosenPage({super.key});

  Future<Map<String, dynamic>?> _fetchChosenCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['chosenCard'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchChosenCard(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final card = snapshot.data!;
        final gradient = _gradientFromList(card['gradientColors']);
        final isSingleImage = (card['icons'] as List).length == 1;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FF),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 270,
                      height: 270,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSingleImage) ...[
                            Text(
                              card['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Image.asset(
                              card['icons'][0],
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(height: 16),
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
                          ] else ...[
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    "Amazing Choice 🎉",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0961F5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0961F5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.rocket_launch, color: Colors.white),
                    label: const Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProgressLoadingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _gradientFromList(List colors) {
    return LinearGradient(
      colors: colors.map<Color>((c) => Color(c)).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
