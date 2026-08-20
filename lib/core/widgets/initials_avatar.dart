import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tinted-circle avatar showing a person's initial — matches the
/// "no placeholder photos" rule from the design system.
class InitialsAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const InitialsAvatar({super.key, required this.name, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final primary = Theme.of(context).colorScheme.primary;
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : "?";

    return CircleAvatar(
      radius: radius,
      backgroundColor: semantic.primarySoft,
      child: Text(
        initial,
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.75,
        ),
      ),
    );
  }
}
