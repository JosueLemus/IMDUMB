import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_colors.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';

class DetailsStats extends StatelessWidget {
  final Movie movie;
  final MovieDetailsState state;
  final bool isDark;

  const DetailsStats({
    super.key,
    required this.movie,
    required this.state,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = state is MovieDetailsLoaded
        ? (state as MovieDetailsLoaded).movie
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem(
          Icons.star_rounded,
          AppColors.ratingStar,
          movie.voteAverage.toStringAsFixed(1),
          'IMDb Score',
          isDark,
        ),
        if (movieDetails != null) ...[
          _statDivider(isDark),
          _statItem(
            Icons.thumb_up_rounded,
            const Color(0xFF4CAF50),
            '${(movieDetails.voteAverage * 10).toInt()}%',
            'User Like',
            isDark,
          ),
        ],
      ],
    );
  }

  Widget _statDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 10 / 255),
    );
  }

  Widget _statItem(
    IconData icon,
    Color iconColor,
    String value,
    String label,
    bool isDark,
  ) {
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
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.movieStatsLabel.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
