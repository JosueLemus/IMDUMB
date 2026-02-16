import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';

class DetailsInfo extends StatelessWidget {
  final Movie movie;
  final MovieDetailsState state;
  final bool isDark;

  const DetailsInfo({
    super.key,
    required this.movie,
    required this.state,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final year = movie.releaseDate.split('-').first;
    final movieDetails = state is MovieDetailsLoaded
        ? (state as MovieDetailsLoaded).movie
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie-poster-${movie.id}',
          child: Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: movie.fullPosterPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                movie.title,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 28,
                  height: 1.1,
                  color: isDark ? Colors.white : Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                '$year${movieDetails != null ? '  •  ${movieDetails.formattedRuntime}' : ''}',
                style: AppTypography.movieMetaInfo.copyWith(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              if (movieDetails != null && movieDetails.genres.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: movieDetails.genres
                      .map((genre) => _genreChip(genre.toUpperCase(), isDark))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _genreChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2A45) : const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.indigo.shade400,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
