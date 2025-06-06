import 'package:code2codes/options/ChosenPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code2codes/options/OptionPage.dart';
import 'package:code2codes/auth/presentation/sign_in.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  Widget? _nextScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        _nextScreen = const SignIn();
        _loading = false;
      });
      return;
    }

    try {
      final profile = await supabase
          .from('profiles')
          .select('chosenCard')
          .eq('id', user.id)
          .maybeSingle();

      if (profile != null && profile['chosenCard'] != null) {
        _nextScreen = const ChosenPage();
      } else {
        _nextScreen = const OptionPage();
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      _nextScreen = const SignIn(); // Fallback
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _nextScreen == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _nextScreen!;
  }
}

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<AuthState>(
//       stream: Supabase.instance.client.auth.onAuthStateChange,
//       builder: (context, snapshot) {
//         final session = snapshot.data?.session;

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (session != null) {
//           return FutureBuilder(
//             future: _checkIfCardChosen(session.user.id),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Scaffold(
//                   body: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               final hasChosenCard = snapshot.data == true;
//               return hasChosenCard ? const ChosenPage() : const OptionPage();
//             },
//           );
//         } else {
//           return const SignIn();
//         }
//       },
//     );
//   }

//   Future<bool> _checkIfCardChosen(String userId) async {
//     final supabase = Supabase.instance.client;
//     final response = await supabase
//         .from('profiles')
//         .select('chosenCard')
//         .eq('id', userId)
//         .maybeSingle();

//     return response?['chosenCard'] != null;
//   }
// }
