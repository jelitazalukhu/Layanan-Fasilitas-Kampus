import 'dart:async';
import 'package:flutter/material.dart';
import 'Screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 70), (timer) {
      setState(() {
        _progress += 0.02;
      });

      if (_progress >= 1) {
        _progress = 1;
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF6),

      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/usu_logo.png',
                width: 110,
              ),
            ),

            const SizedBox(height: 24),

            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: const [
                    Text(
                      "CampusFind",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF064E3B),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Your Smart Way to Access Campus Facilities",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFD1FAE5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF065F46), // hijau gelap
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Loading ${(_progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
