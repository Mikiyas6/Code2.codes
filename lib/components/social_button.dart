import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInSocialButton extends StatelessWidget {
  final Size size;
  final String iconPath;
  final String text;
  final VoidCallback? onPressed; // <-- Add this

  const SignInSocialButton({
    super.key,
    required this.size,
    required this.iconPath,
    required this.text,
    this.onPressed, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // <-- Use it here
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
                  fontSize: 16.0, // Match your sign up style
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
