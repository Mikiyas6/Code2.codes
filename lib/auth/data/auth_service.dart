import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId:
              '312590696826-drhdmopqr4dcdn51dltl0nt13b2npn1c.apps.googleusercontent.com',
        )
      : GoogleSignIn();

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Anonymous sign-in error: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Email sign-in error: $e");
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        // Add user to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          // Add more fields as needed
        });
      }
      return user;
    } catch (e) {
      print("Email registration error: $e");
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // First time: create the user document
          await userDoc.set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastSignedIn': FieldValue.serverTimestamp(),
          });
        } else {
          // User exists: only update lastSignedIn
          await userDoc.update({'lastSignedIn': FieldValue.serverTimestamp()});
        }
      }

      return user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  // Register with Google (same as sign-in)
  Future<User?> registerWithGoogle() async => signInWithGoogle();

  // Sign in with GitHub
  Future<User?> signInWithGitHub() async {
    try {
      final githubProvider = GithubAuthProvider();
      UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          githubProvider,
        );
      } else {
        userCredential = await FirebaseAuth.instance.signInWithProvider(
          githubProvider,
        );
      }

      final user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'provider': 'github',
            'createdAt': FieldValue.serverTimestamp(),
            'lastSignedIn': FieldValue.serverTimestamp(),
          });
        } else {
          await userDoc.update({'lastSignedIn': FieldValue.serverTimestamp()});
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        final pendingCred = e.credential;
        final email = e.email;

        // Step 1: Fetch sign-in methods for this email
        final signInMethods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(email!);

        if (signInMethods.contains('google.com')) {
          // Prompt user to sign in with Google first
          final googleUser = await GoogleSignIn().signIn();
          final googleAuth = await googleUser!.authentication;
          final googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in with Google
          final googleUserCred = await FirebaseAuth.instance
              .signInWithCredential(googleCredential);

          // Step 2: Link GitHub to the existing Google account
          await googleUserCred.user?.linkWithCredential(pendingCred!);

          return googleUserCred.user;
        } else {
          print("Account exists with different provider: $signInMethods");
          // Optionally, show UI prompt to log in with the correct provider
        }
      }

      print("GitHub sign-in failed: ${e.message}");
      return null;
    } catch (e) {
      print("GitHub sign-in error: $e");
      return null;
    }
  }

  // Register with GitHub (same as sign-in)
  Future<User?> registerWithGitHub() async => signInWithGitHub();

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print("Sign-out error: $e");
    }
  }
}
