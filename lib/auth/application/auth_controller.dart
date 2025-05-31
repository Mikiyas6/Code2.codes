import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Example sign in method
  Future<void> signIn(String email, String password) async {
    setLoading(true);
    clearError();
    try {
      // TODO: Implement your authentication logic here
      await Future.delayed(const Duration(seconds: 2));
      // If successful, do nothing or update state as needed
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // Example sign out method
  Future<void> signOut() async {
    setLoading(true);
    try {
      // TODO: Implement your sign out logic here
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}