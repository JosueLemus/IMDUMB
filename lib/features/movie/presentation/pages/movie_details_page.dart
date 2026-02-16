import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movie_details_bloc.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late ScrollController _scrollController;
  bool _showCollapsedTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool showTitle =
        _scrollController.hasClients && _scrollController.offset > 320;
    if (showTitle != _showCollapsedTitle) {
      setState(() => _showCollapsedTitle = showTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) =>
          sl<MovieDetailsBloc>()..add(FetchMovieDetails(widget.movie.id)),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildIntegratedHeader(context, state),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildBodyContent(context, state),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _buildPinnedAppBar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPinnedAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: statusBarHeight, bottom: 8),
        decoration: BoxDecoration(
          color: _showCollapsedTitle
              ? (isDark ? AppColors.darkBackground : AppColors.lightBackground)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            _circleIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              backgroundColor: _showCollapsedTitle
                  ? Colors.transparent
                  : AppColors.overlayButtonBackground,
              iconColor: _showCollapsedTitle
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showCollapsedTitle ? 1.0 : 0.0,
                child: Text(
                  widget.movie.title,
                  style: AppTypography.movieAppBarTitle.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _circleIconButton(
              icon: Icons.favorite_border,
              onPressed: () {},
              backgroundColor: _showCollapsedTitle
                  ? Colors.transparent
                  : AppColors.overlayButtonBackground,
              iconColor: _showCollapsedTitle
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.white,
            ),
            const SizedBox(width: 8),
            _circleIconButton(
              icon: Icons.share,
              onPressed: () {},
              backgroundColor: _showCollapsedTitle
                  ? Colors.transparent
                  : AppColors.overlayButtonBackground,
              iconColor: _showCollapsedTitle
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.white,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegratedHeader(BuildContext context, MovieDetailsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backdropPath = widget.movie.backdropPath;
    final fullBackdrop = backdropPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
        : widget.movie.fullPosterPath;

    final year = widget.movie.releaseDate.split('-').first;
    String runtime = '--';
    if (state is MovieDetailsLoaded) {
      runtime = state.movie.formattedRuntime;
    }

    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: fullBackdrop,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 120,
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 150,
            child: Container(
              height: 151,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: 'movie-poster-${widget.movie.id}',
                  child: Container(
                    width: 130,
                    height: 195,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 160 : 60),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: widget.movie.fullPosterPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.movie.title.toUpperCase(),
                          style: AppTypography.movieTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(year, style: AppTypography.movieMetaInfo),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(runtime, style: AppTypography.movieMetaInfo),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: iconColor, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, MovieDetailsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<String> genres = [];
    if (state is MovieDetailsLoaded) {
      genres = state.movie.genres;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.ratingStar,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.movie.voteAverage.toStringAsFixed(1),
                      style: AppTypography.movieStatsValue.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const Text('IMDUMB', style: AppTypography.movieStatsLabel),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 32,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            const SizedBox(width: 16),
            const Column(
              children: [
                Text('92%', style: AppTypography.movieStatsValue),
                Text('Tomato', style: AppTypography.movieStatsLabel),
              ],
            ),
            const Spacer(),
            ...genres
                .take(2)
                .map(
                  (genre) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(genre, style: AppTypography.genreChip),
                    ),
                  ),
                ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Storyline',
          style: AppTypography.sectionHeader.copyWith(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.movie.overview,
          style: AppTypography.movieOverview.copyWith(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
