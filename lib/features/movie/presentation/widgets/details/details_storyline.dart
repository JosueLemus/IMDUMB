import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';

class DetailsStoryline extends StatelessWidget {
  final Movie movie;

  const DetailsStoryline({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storyline',
          style: AppTypography.sectionHeader.copyWith(
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          movie.overview,
          style: AppTypography.movieOverview.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.8,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
