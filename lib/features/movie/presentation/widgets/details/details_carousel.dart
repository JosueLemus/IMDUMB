import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdumb/core/theme/app_colors.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/movie_details_bloc.dart';

import 'details_app_bar_button.dart';

class DetailsCarousel extends StatelessWidget {
  final Movie movie;
  final MovieDetailsState state;
  final bool isDark;
  final double height;
  final bool showCollapsedTitle;
  final int currentPage;
  final PageController pageController;
  final Function(int) onPageChanged;
  final VoidCallback onBack;

  const DetailsCarousel({
    super.key,
    required this.movie,
    required this.state,
    required this.isDark,
    required this.height,
    required this.showCollapsedTitle,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final backdropPath = movie.backdropPath;
    final fullBackdrop = backdropPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
        : movie.fullPosterPath;

    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: DetailsAppBarButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: onBack,
          isDark: isDark,
          scrolled: showCollapsedTitle,
        ),
      ),
      actions: [
        DetailsAppBarButton(
          icon: Icons.share_rounded,
          onPressed: () {},
          isDark: isDark,
          scrolled: showCollapsedTitle,
        ),
        const SizedBox(width: 12),
      ],
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: state is MovieDetailsLoaded
                  ? ((state as MovieDetailsLoaded).movie.backdrops.isNotEmpty
                        ? (state as MovieDetailsLoaded).movie.backdrops.length
                        : 1)
                  : 1,
              itemBuilder: (context, index) {
                final image =
                    state is MovieDetailsLoaded &&
                        (state as MovieDetailsLoaded).movie.backdrops.isNotEmpty
                    ? (state as MovieDetailsLoaded)
                          .movie
                          .fullBackdropPaths[index]
                    : fullBackdrop;
                return CachedNetworkImage(imageUrl: image, fit: BoxFit.cover);
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            if (state is MovieDetailsLoaded &&
                (state as MovieDetailsLoaded).movie.backdrops.length > 1)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    (state as MovieDetailsLoaded).movie.backdrops.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      width: currentPage == index ? 24 : 12,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: showCollapsedTitle ? 1.0 : 0.0,
          child: Text(
            movie.title,
            style: AppTypography.movieAppBarTitle.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
