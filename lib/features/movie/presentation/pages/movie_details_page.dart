import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movie_details_bloc.dart';
import '../widgets/details/details_actions.dart';
import '../widgets/details/details_carousel.dart';
import '../widgets/details/details_info.dart';
import '../widgets/details/details_stats.dart';
import '../widgets/details/details_storyline.dart';

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
                DetailsCarousel(
                  movie: widget.movie,
                  state: state,
                  isDark: isDark,
                  height: carouselHeight,
                  showCollapsedTitle: _showCollapsedTitle,
                  currentPage: _currentPage,
                  pageController: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  onBack: () => Navigator.pop(context),
                ),
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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          DetailsInfo(movie: widget.movie, state: state, isDark: isDark),
          const SizedBox(height: 32),
          DetailsActions(isDark: isDark),
          const SizedBox(height: 24),
          DetailsStats(movie: widget.movie, state: state, isDark: isDark),
          const SizedBox(height: 32),
          DetailsStoryline(movie: widget.movie, isDark: isDark),
        ],
      ),
    );
  }
}
