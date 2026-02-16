import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 260,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const shadowColor = Color(0x80000000);
    const overlayGradientBase = Color(0x33000000);
    const overlayGradientEnd = Color(0xCC000000);
    const dotSeparatorColor = Color(0x8CFFFFFF);
    const yearColor = Color(0xB3FFFFFF);
    const saveButtonBackground = Color(0x33FFFFFF);

    return GestureDetector(
      onTap: () => context.push('/movie-details', extra: movie),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Hero(
              tag: 'movie-poster-${movie.id}',
              child: CachedNetworkImage(
                imageUrl: movie.fullPosterPath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                memCacheWidth: 600,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: isDark
                      ? const Color(0xFF1E1B2E)
                      : const Color(0xFFF3F4F6),
                  highlightColor: isDark
                      ? const Color(0xFF2D2A3E)
                      : const Color(0xFFFFFFFF),
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark
                      ? AppColors.darkAltSurface
                      : AppColors.lightAltBackground,
                  child: Icon(
                    Icons.error,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      overlayGradientBase,
                      overlayGradientEnd,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '•',
                        style: TextStyle(color: dotSeparatorColor),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        movie.releaseDate.split('-').first,
                        style: textTheme.bodyMedium?.copyWith(color: yearColor),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: saveButtonBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_border_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
