import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import "../../auth/data/auth_service.dart";

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password must not be empty')),
      );
      return;
    }

    final user = await _authService.signInWithEmailAndPassword(email, password);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in. Please try again.')),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/options');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logo(size.height / 8, size.height / 8),
                    SizedBox(height: size.height * 0.03),
                    richText(),
                    SizedBox(height: size.height * 0.03),
                    SignInSocialButton(
                      iconPath: 'assets/google_logo.svg',
                      text: 'Continue with Google',
                      onPressed: () async {
                        final user = await _authService.signInWithGoogle();
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google sign-in failed.'),
                            ),
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      size: size,
                    ),
                    SizedBox(height: size.height * 0.03),
                    SignInSocialButton(
                      iconPath: 'assets/github_logo.svg',
                      text: 'Continue with Github',
                      onPressed: () async {
                        final user = await _authService.signInWithGitHub();
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('GitHub sign-in failed.'),
                            ),
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      size: size,
                    ),
                    SizedBox(height: size.height * 0.02),
                    signInWithText(),
                    SizedBox(height: size.height * 0.02),
                    emailTextField(size),
                    SizedBox(height: size.height * 0.02),
                    passwordTextField(size),
                    SizedBox(height: size.height * 0.03),
                    signInButton(size),
                    SizedBox(height: size.height * 0.02),
                    footerText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.asset(
      'assets/logo.jpg',
      height: height_,
      width: width_,
      fit: BoxFit.cover,
    ),
  );

  Widget richText() => Text(
    'Sign In',
    style: GoogleFonts.inter(
      fontSize: 22,
      color: const Color(0xFF0961F5),
      fontWeight: FontWeight.w600,
    ),
    textAlign: TextAlign.center,
  );

  Widget signInWithText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: Color.fromARGB(255, 0, 0, 0), // Light gray divider
            thickness: 0.1,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Or',
          style: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Divider(
            color: Color.fromARGB(255, 0, 0, 0), // Light gray divider
            thickness: 0.1,
          ),
        ),
      ],
    );
  }

  Widget emailTextField(Size size) => _inputField(
    focusNode: _emailFocus,
    controller: _emailController,
    label: 'Email/Phone number',
    isPassword: false,
    size: size,
  );

  Widget passwordTextField(Size size) => _inputField(
    focusNode: _passwordFocus,
    controller: _passwordController,
    label: 'Password',
    isPassword: true,
    size: size,
  );

  Widget _inputField({
    required FocusNode focusNode,
    required TextEditingController controller,
    required String label,
    required bool isPassword,
    required Size size,
  }) {
    final isFocused = focusNode.hasFocus;
    return Container(
      height: size.height / 11,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        gradient: isFocused
            ? const LinearGradient(
                colors: [Color(0xFF0961F5), Color(0xFF7F56D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isFocused ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword ? _obscurePassword : false,
          onTap: () => setState(() {}),
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF15224F),
          ),
          cursorColor: const Color(0xFF15224F),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF969AA8),
                    ),
                    onPressed: () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    }),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget signInButton(Size size) => GestureDetector(
    onTap: _handleEmailPasswordSignIn,
    child: Container(
      height: size.height / 11,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: const Color(0xFF0961F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Sign In',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF0961F5),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget footerText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF15224F),
          fontWeight: FontWeight.w400,
        ),
        children: [
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: 'Sign Up',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0961F5),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
          ),
        ],
      ),
    );
  }
}

class SignInSocialButton extends StatelessWidget {
  final Size size;
  final String iconPath;
  final String text;
  final VoidCallback? onPressed;

  const SignInSocialButton({
    super.key,
    required this.size,
    required this.iconPath,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: size.height / 12,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16.0, // Match this to the value in sign_up.dart
                  color: const Color(0xFF134140),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
