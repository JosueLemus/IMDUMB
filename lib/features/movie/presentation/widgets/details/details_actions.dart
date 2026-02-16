import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_colors.dart';

class DetailsActions extends StatelessWidget {
  final bool isDark;

  const DetailsActions({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: AppColors.primary.withValues(alpha: 0.4),
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
            color: isDark ? const Color(0xFF2D2A45) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.grey,
              size: 24,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
