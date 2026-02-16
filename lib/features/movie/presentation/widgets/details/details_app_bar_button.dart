import 'package:flutter/material.dart';

class DetailsAppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;
  final bool scrolled;

  const DetailsAppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isDark,
    required this.scrolled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: scrolled
            ? Colors.transparent
            : Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: scrolled
              ? (isDark ? Colors.white : Colors.black)
              : Colors.white,
          size: 18,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
