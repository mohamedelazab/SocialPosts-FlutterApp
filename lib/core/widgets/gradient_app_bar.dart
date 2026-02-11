import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color> colors;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;

  const GradientAppBar({
    super.key,
    required this.title,
    this.colors = const [Color(0xFF1E88E5), Color(0xFF1565C0)],
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: elevation,
        centerTitle: centerTitle,
        foregroundColor: Colors.white,
        leading: leading,
        actions: actions,
      ),
    );
  }
}
