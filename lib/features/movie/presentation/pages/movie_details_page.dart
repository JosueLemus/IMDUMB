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
  late PageController _pageController;
  bool _showCollapsedTitle = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool showTitle =
        _scrollController.hasClients && _scrollController.offset > 400;
    if (showTitle != _showCollapsedTitle) {
      setState(() => _showCollapsedTitle = showTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final carouselHeight = size.height * 0.3;

    return BlocProvider(
      create: (context) =>
          sl<MovieDetailsBloc>()..add(FetchMovieDetails(widget.movie.id)),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : const Color(0xFFF8F9FB),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverCarousel(carouselHeight, state, isDark),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -32),
                    child: _buildContentCard(context, state, isDark),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverCarousel(
    double height,
    MovieDetailsState state,
    bool isDark,
  ) {
    final backdropPath = widget.movie.backdropPath;
    final fullBackdrop = backdropPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
        : widget.movie.fullPosterPath;

    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _appBarButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.pop(context),
          isDark: isDark,
          scrolled: _showCollapsedTitle,
        ),
      ),
      actions: [
        _appBarButton(
          icon: Icons.share_rounded,
          onPressed: () {},
          isDark: isDark,
          scrolled: _showCollapsedTitle,
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
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: state is MovieDetailsLoaded
                  ? (state.movie.backdrops.isNotEmpty
                        ? state.movie.backdrops.length
                        : 1)
                  : 1,
              itemBuilder: (context, index) {
                final image =
                    state is MovieDetailsLoaded &&
                        state.movie.backdrops.isNotEmpty
                    ? state.movie.fullBackdropPaths[index]
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ),
            if (state is MovieDetailsLoaded && state.movie.backdrops.length > 1)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.movie.backdrops.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      width: _currentPage == index ? 24 : 12,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
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
          opacity: _showCollapsedTitle ? 1.0 : 0.0,
          child: Text(
            widget.movie.title,
            style: AppTypography.movieAppBarTitle.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context,
    MovieDetailsState state,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildMainInfoRow(context, isDark),
          const SizedBox(height: 32),
          _buildActionsRow(context, isDark),
          const SizedBox(height: 48),
          _buildStatsRow(context, isDark, state),
          const SizedBox(height: 40),
          _buildStoryline(isDark),
        ],
      ),
    );
  }

  Widget _buildMainInfoRow(BuildContext context, bool isDark) {
    final year = widget.movie.releaseDate.split('-').first;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie-poster-${widget.movie.id}',
          child: Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
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
            children: [
              const SizedBox(height: 8),
              Text(
                widget.movie.title,
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
                '$year  •  2h 49m  •  PG-13',
                style: AppTypography.movieMetaInfo.copyWith(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _genreChip('SCI-FI', isDark),
                  _genreChip('DRAMA', isDark),
                ],
              ),
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

  Widget _buildActionsRow(BuildContext context, bool isDark) {
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
              shadowColor: AppColors.primary.withOpacity(0.4),
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

  Widget _buildStatsRow(
    BuildContext context,
    bool isDark,
    MovieDetailsState state,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem(
          Icons.star_rounded,
          AppColors.ratingStar,
          widget.movie.voteAverage.toStringAsFixed(1),
          'IMDb Score',
          isDark,
        ),
        _statDivider(isDark),
        _statItem(
          Icons.thumb_up_rounded,
          const Color(0xFF4CAF50),
          '94%',
          'User Like',
          isDark,
        ),
        _statDivider(isDark),
        _statItem(
          Icons.emoji_events_rounded,
          const Color(0xFF9C27B0),
          '#20',
          'Ranking',
          isDark,
        ),
      ],
    );
  }

  Widget _statDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
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

  Widget _buildStoryline(bool isDark) {
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
          widget.movie.overview,
          style: AppTypography.movieOverview.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
            height: 1.8,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _appBarButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    required bool scrolled,
  }) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: scrolled ? Colors.transparent : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: scrolled
              ? (isDark ? Colors.white : Colors.black)
              : Colors.white,
          size: 18,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
