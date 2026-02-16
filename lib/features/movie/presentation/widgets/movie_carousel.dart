import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/now_playing_bloc.dart';
import 'movie_card.dart';

class MovieCarousel extends StatelessWidget {
  const MovieCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingBloc, NowPlayingState>(
      builder: (context, state) {
        if (state is NowPlayingInitial ||
            (state is NowPlayingLoading && state is! NowPlayingLoaded)) {
          return const SizedBox(
            height: 450,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NowPlayingError) {
          return SizedBox(
            height: 450,
            child: Center(child: Text('Error: ${state.message}')),
          );
        }

        if (state is NowPlayingLoaded) {
          final movies = state.movies;

          return SizedBox(
            height: 450,
            child: CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (context, index, realIndex) {
                return MovieCard(movie: movies[index], width: double.infinity);
              },
              options: CarouselOptions(
                height: 420,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  if (index >= movies.length - 3 && !state.hasReachedMax) {
                    context.read<NowPlayingBloc>().add(
                      const FetchNowPlayingMovies(),
                    );
                  }
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
