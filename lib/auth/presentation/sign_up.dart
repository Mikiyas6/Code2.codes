import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/social_button.dart';
import '../../auth/data/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _showEmailFields = false; // <-- Add this

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  logo(size.height / 8, size.height / 8),
                  SizedBox(height: size.height * 0.03),
                  titleText(),
                  SizedBox(height: size.height * 0.03),
                  SignInSocialButton(
                    key: const ValueKey('google_sign_up'),
                    iconPath: 'assets/google_logo.svg',
                    text: 'Continue with Google',
                    size: size,
                    onPressed: () async {
                      final user = await _authService.signInWithGoogle();
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Google sign-in failed.'),
                          ),
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/options');
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  SignInSocialButton(
                    key: const ValueKey('github_sign_up'),
                    iconPath: 'assets/github_logo.svg',
                    text: 'Continue with Github',
                    size: size,
                    onPressed: () async {
                      final user = await _authService.signInWithGitHub();
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('GitHub sign-in failed.'),
                          ),
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/options');
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  orDivider(),
                  SizedBox(height: size.height * 0.02),
                  // Show "Continue with Email" button or the fields
                  if (!_showEmailFields)
                    SignInSocialButton(
                      key: const ValueKey('email_sign_up'),
                      iconPath:
                          'assets/email_icon.svg', // Use your email SVG asset here
                      text: 'Continue with Email',
                      size: size,
                      onPressed: () {
                        setState(() {
                          _showEmailFields = true;
                        });
                      },
                    ),
                  if (_showEmailFields) ...[
                    emailTextField(size),
                    SizedBox(height: size.height * 0.02),
                    passwordTextField(size),
                    SizedBox(height: size.height * 0.02),
                    termsCheckbox(),
                    SizedBox(height: size.height * 0.03),
                    signUpButton(size, () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (!_agreeToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You must agree to the terms.'),
                          ),
                        );
                        return;
                      }
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields.'),
                          ),
                        );
                        return;
                      }

                      final user = await _authService
                          .registerWithEmailAndPassword(email, password);
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign up failed.')),
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/options');
                      }
                    }),
                  ],
                  SizedBox(height: size.height * 0.02),
                  footerText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/logo.jpg',
        height: height_,
        width: width_,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget titleText() {
    return Text(
      'Sign Up',
      style: GoogleFonts.inter(
        fontSize: 20,
        color: const Color(0xFF0961F5),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget emailTextField(Size size) {
    bool isFocused = _emailFocus.hasFocus;
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
          controller: _emailController,
          focusNode: _emailFocus,
          onTap: () => setState(() {}),
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF15224F),
          ),
          maxLines: 1,
          cursorColor: const Color(0xFF15224F),
          decoration: InputDecoration(
            labelText: 'Email or Phone number',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    bool isFocused = _passwordFocus.hasFocus;
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
          controller: _passwordController,
          focusNode: _passwordFocus,
          onTap: () => setState(() {}),
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF15224F),
          ),
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          cursorColor: const Color(0xFF15224F),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF969AA8),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget termsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _agreeToTerms
                ? const Color(0xFF0961F5)
                : const Color(0xFFC8E1FD),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: 22,
          height: 22,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (bool? value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF15224F),
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'terms of service',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0961F5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'privacy policy',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0961F5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton(Size size, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
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
              'Sign Up',
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

  Widget orDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color.fromARGB(255, 213, 212, 212),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Or'),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color.fromARGB(255, 213, 212, 212),
          ),
        ),
      ],
    );
  }

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
          const TextSpan(text: 'Already have an account? '),
          TextSpan(
            text: 'Sign In',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0961F5),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
          ),
        ],
      ),
    );
  }
}
