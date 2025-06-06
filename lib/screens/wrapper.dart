import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code2codes/options/OptionPage.dart';
import 'package:code2codes/auth/presentation/sign_in.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OptionPage()),
        );
      }
    });
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        _handleUri(uri);
      });
      getInitialUri().then(_handleUri);
    }
  }

  void _handleUri(Uri? uri) {
    if (uri != null && uri.toString().contains("login-callback")) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OptionPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return OptionPage();
    } else {
      return SignIn();
    }
  }
}
