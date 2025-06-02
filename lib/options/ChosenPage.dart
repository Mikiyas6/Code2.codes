import 'package:code2codes/options/ProgressLoadingScreen.dart';
import 'package:flutter/material.dart';

class ChosenPage extends StatelessWidget {
  final Map<String, dynamic> chosenCard;
  const ChosenPage({super.key, required this.chosenCard});

  @override
  Widget build(BuildContext context) {
    final isSingleImage = (chosenCard['icons'] as List).length == 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Back arrow button at the top
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Card display
              Container(
                width: 270,
                height: 200,
                decoration: BoxDecoration(
                  gradient: chosenCard['gradient'],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: isSingleImage
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chosenCard['title'],
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
                            chosenCard['icons'][0],
                            width: 90,
                            height: 90,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              chosenCard['desc'],
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
                            children: (chosenCard['icons'] as List<String>)
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
                            chosenCard['title'],
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
                              chosenCard['desc'],
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
              const SizedBox(height: 40),
              const Text(
                'Amazing Choice 🎉',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0961F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProgressLoadingScreen(chosenCard: chosenCard),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
