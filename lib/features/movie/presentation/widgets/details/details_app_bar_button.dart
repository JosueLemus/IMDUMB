import 'package:flutter/material.dart';

class DetailsAppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool scrolled;

  const DetailsAppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.scrolled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: scrolled
            ? Colors.transparent
            : colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: scrolled ? colorScheme.onSurface : colorScheme.onSurface,
          size: 18,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
