import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/application/auth_controller.dart';
import '../auth/data/auth_service.dart';

/// Provides AuthService as a singleton.
final authServiceProvider = AuthService();

/// Provides AuthController as a ChangeNotifier for state management.
class AuthControllerProvider extends StatelessWidget {
  final Widget child;

  const AuthControllerProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (_) => AuthController(),
      child: child,
    );
  }
}
