import 'dart:async';
import 'package:active_gauges/screens/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _shrinkController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showMainApp = false;

  @override
  void initState() {
    super.initState();

    // 1. Fade in logo
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // 2. Prepare shrink and slide animation
    _shrinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _shrinkController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, .85), // move up
        ).animate(
          CurvedAnimation(parent: _shrinkController, curve: Curves.easeInOut),
        );

    // 3. Start shrink/slide, then switch screens
    Timer(const Duration(milliseconds: 1500), () {
      _shrinkController.forward();
    });

    Timer(const Duration(milliseconds: 2400), () {
      setState(() => _showMainApp = true);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shrinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Branded logo animation
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    width: 500,
                  ),
                ),
              ),
            ),
          ),

          // Main App fades in after
          AnimatedOpacity(
            opacity: _showMainApp ? 1 : 0,
            duration: const Duration(milliseconds: 1600),
            child: _showMainApp ? const HomePage() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
