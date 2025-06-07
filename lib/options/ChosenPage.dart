import 'package:code2codes/options/ProgressLoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChosenPage extends StatefulWidget {
  const ChosenPage({super.key});

  @override
  State<ChosenPage> createState() => _ChosenPageState();
}

class _ChosenPageState extends State<ChosenPage>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ✅ FIXED: Fetch from 'profiles' instead of 'users'
  Future<Map<String, dynamic>?> _fetchChosenCard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    final response = await Supabase.instance.client
        .from('profiles')
        .select('chosenCard')
        .eq('id', user.id)
        .maybeSingle();

    return response?['chosenCard'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchChosenCard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('No card selected.')));
        }

        final card = snapshot.data!;
        final gradient = _gradientFromList(card['gradientColors']);
        final isSingleImage = (card['icons'] as List).length == 1;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FF),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.08,
                numberOfParticles: 18,
                maxBlastForce: 18,
                minBlastForce: 8,
                gravity: 0.18,
                colors: const [
                  Color(0xFF60A5FA),
                  Color(0xFF10B981),
                  Color(0xFFA78BFA),
                  Color(0xFFFDE68A),
                  Color(0xFF166534),
                  Color(0xFF14B8A6),
                  Color(0xFF0961F5),
                ],
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: gradient.colors.first.withOpacity(0.4),
                                  blurRadius: 32,
                                  spreadRadius: 4,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: Material(
                              elevation: 10,
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
                                          fontSize: 20,
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
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            List<String>.from(
                                                  card['icons'] as List,
                                                )
                                                .map(
                                                  (icon) => Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
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
                                          fontSize: 20,
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
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            "Amazing Choice 🎉",
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0961F5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "You're on your way to something great. Get ready to shine!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 28),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0961F5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF60A5FA),
                            ),
                            icon: const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 26,
                            ),
                            label: const Text(
                              "Let's Get Started",
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed('/progressLoadingScreen');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

// import 'package:code2codes/options/ProgressLoadingScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:confetti/confetti.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChosenPage extends StatefulWidget {
//   const ChosenPage({super.key});

//   @override
//   State<ChosenPage> createState() => _ChosenPageState();
// }

// class _ChosenPageState extends State<ChosenPage>
//     with SingleTickerProviderStateMixin {
//   late ConfettiController _confettiController;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(
//       duration: const Duration(seconds: 2),
//     );
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _fadeAnim = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     );
//     _fadeController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _confettiController.play();
//     });
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   // Fetch chosenCard from Supabase users table
//   Future<Map<String, dynamic>?> _fetchChosenCard() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return null;
//     final response = await Supabase.instance.client
//         .from('users')
//         .select('chosenCard')
//         .eq('id', user.id)
//         .maybeSingle();
//     return response?['chosenCard'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>?>(
//       future: _fetchChosenCard(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         final card = snapshot.data!;
//         final gradient = _gradientFromList(card['gradientColors']);
//         final isSingleImage = (card['icons'] as List).length == 1;

//         return Scaffold(
//           backgroundColor: const Color(0xFFF5F9FF),
//           body: Stack(
//             alignment: Alignment.topCenter,
//             children: [
//               // Confetti
//               ConfettiWidget(
//                 confettiController: _confettiController,
//                 blastDirectionality: BlastDirectionality.explosive,
//                 shouldLoop: false,
//                 emissionFrequency: 0.08,
//                 numberOfParticles: 18,
//                 maxBlastForce: 18,
//                 minBlastForce: 8,
//                 gravity: 0.18,
//                 colors: const [
//                   Color(0xFF60A5FA),
//                   Color(0xFF10B981),
//                   Color(0xFFA78BFA),
//                   Color(0xFFFDE68A),
//                   Color(0xFF166534),
//                   Color(0xFF14B8A6),
//                   Color(0xFF0961F5),
//                 ],
//               ),
//               Center(
//                 child: FadeTransition(
//                   opacity: _fadeAnim,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 80.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Glowing border effect
//                           Container(
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: gradient.colors.first.withOpacity(0.4),
//                                   blurRadius: 32,
//                                   spreadRadius: 4,
//                                 ),
//                               ],
//                               borderRadius: BorderRadius.circular(36),
//                             ),
//                             child: Material(
//                               elevation: 10,
//                               borderRadius: BorderRadius.circular(30),
//                               child: Container(
//                                 width: 270,
//                                 height: 270,
//                                 decoration: BoxDecoration(
//                                   gradient: gradient,
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     if (isSingleImage) ...[
//                                       Text(
//                                         card['title'],
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Image.asset(
//                                         card['icons'][0],
//                                         width: 90,
//                                         height: 90,
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12.0,
//                                         ),
//                                         child: Text(
//                                           card['desc'],
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             fontFamily: 'Mulish',
//                                             fontSize: 13,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ] else ...[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children:
//                                             List<String>.from(
//                                                   card['icons'] as List,
//                                                 )
//                                                 .map(
//                                                   (icon) => Padding(
//                                                     padding:
//                                                         const EdgeInsets.symmetric(
//                                                           horizontal: 4.0,
//                                                         ),
//                                                     child: Image.asset(
//                                                       icon,
//                                                       width: 32,
//                                                       height: 32,
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                       ),
//                                       const SizedBox(height: 10),
//                                       Text(
//                                         card['title'],
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12.0,
//                                         ),
//                                         child: Text(
//                                           card['desc'],
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             fontFamily: 'Mulish',
//                                             fontSize: 13,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 32),
//                           const Text(
//                             "Amazing Choice 🎉",
//                             style: TextStyle(
//                               fontFamily: 'Jost',
//                               fontSize: 22,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF0961F5),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             "You're on your way to something great. Get ready to shine!",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontFamily: 'Mulish',
//                               fontSize: 15,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           const SizedBox(height: 28),
//                           ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF0961F5),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 16,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                               elevation: 4,
//                               shadowColor: const Color(0xFF60A5FA),
//                             ),
//                             icon: const Icon(
//                               Icons.rocket_launch,
//                               color: Colors.white,
//                               size: 26,
//                             ),
//                             label: const Text(
//                               "Let's Get Started",
//                               style: TextStyle(
//                                 fontFamily: 'Jost',
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ProgressLoadingScreen(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   LinearGradient _gradientFromList(List colors) {
//     return LinearGradient(
//       colors: colors.map<Color>((c) => Color(c)).toList(),
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );
//   }
// }
