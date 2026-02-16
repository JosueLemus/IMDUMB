import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_colors.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';

class DetailsStats extends StatelessWidget {
  final Movie movie;
  final MovieDetailsState state;

  const DetailsStats({super.key, required this.movie, required this.state});

  @override
  Widget build(BuildContext context) {
    final movieDetails = state is MovieDetailsLoaded
        ? (state as MovieDetailsLoaded).movie
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem(
          context,
          Icons.star_rounded,
          AppColors.warning,
          movie.voteAverage.toStringAsFixed(1),
          'IMDb Score',
        ),
        if (movieDetails != null) ...[
          _statDivider(context),
          _statItem(
            context,
            Icons.thumb_up_rounded,
            AppColors.success,
            '${(movieDetails.voteAverage * 10).toInt()}%',
            'User Like',
          ),
        ],
      ],
    );
  }

  Widget _statDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _statItem(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String value,
    String label,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              value,
              style: AppTypography.movieStatsValue.copyWith(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.movieStatsLabel.copyWith(
            fontSize: 11,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
