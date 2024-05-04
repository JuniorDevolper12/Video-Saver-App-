import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TyperText extends StatelessWidget {
  const TyperText({
    super.key,
    required this.h,
  });

  final double h;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: h * 0.3),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Made With ❤️',
              textStyle: GoogleFonts.pressStart2p(
                textStyle: const TextStyle(
                    color: Colors.red, letterSpacing: 2, fontSize: 15),
              ),
              speed: const Duration(milliseconds: 300),
            ),
          ],
          totalRepeatCount: 1000,
          pause: const Duration(milliseconds: 200),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ));
  }
}

class FadeText extends StatelessWidget {
  const FadeText({
    super.key,
    required this.h,
  });

  final double h;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: h * 0.07, bottom: 20),
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          FadeAnimatedText('Paste Any Url From Any Social Media',
              duration: const Duration(milliseconds: 2000),
              textStyle: GoogleFonts.aBeeZee(
                textStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ],
      ),
    );
  }
}
