import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';

class DetailsStoryline extends StatelessWidget {
  final Movie movie;
  final bool isDark;

  const DetailsStoryline({
    super.key,
    required this.movie,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storyline',
          style: AppTypography.sectionHeader.copyWith(
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          movie.overview,
          style: AppTypography.movieOverview.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
            height: 1.8,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
