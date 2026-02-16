import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../movie/domain/entities/genre.dart';

class CategoryBannerWidget extends StatelessWidget {
  final Genre genre;
  final VoidCallback onTap;

  const CategoryBannerWidget({
    super.key,
    required this.genre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    if (genre.bannerUrl != null && genre.bannerUrl!.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: genre.bannerUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.movie_filter,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.movie_filter,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: Text(
              genre.name,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
