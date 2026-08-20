import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToFeed());
  }

  Future<void> _goToFeed() async {
    // Brief brand beat, not a fake network wait.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.replace('/feed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16261F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 74,
              width: 74,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.groups_outlined, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Commons",
              style: TextStyle(
                fontFamily: 'serif',
                color: Colors.white,
                fontSize: 26,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "where your circle shows up",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
