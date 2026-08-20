import 'package:flutter/material.dart';

/// Centered progress indicator for full-screen / full-tab loading states.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
