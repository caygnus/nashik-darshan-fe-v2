import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nashik/core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = 'SplashScreen';
  static const routePath = '/SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool showSecondText = false;
  bool showButton = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize button animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Centered animated text
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Welcome to Nashik" with typewriter effect
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to Nashik',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    onFinished: () {
                      setState(() {
                        showSecondText = true;
                      });
                    },
                  ),

                  const SizedBox(height: 10.0),

                  // "Darshan" with typewriter effect
                  if (showSecondText)
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Darshan',
                          textStyle: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                          ),
                          speed: const Duration(milliseconds: 60),
                        ),
                      ],
                      totalRepeatCount: 1,
                      onFinished: () {
                        _controller.forward();
                        // TODO
                        // Approuter.router.goNamed(LoginPage.routeName);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
