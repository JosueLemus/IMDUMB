import 'package:flutter/material.dart';

class DetailsActions extends StatelessWidget {
  const DetailsActions({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 24),
            label: const Text(
              'Watch',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 8,
              shadowColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.4),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: Icon(
              Icons.favorite_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
