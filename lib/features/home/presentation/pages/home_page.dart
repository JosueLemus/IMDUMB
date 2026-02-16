import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/core/di/injection_container.dart';
import 'package:imdumb/features/movie/presentation/bloc/now_playing_bloc.dart';
import 'package:imdumb/features/movie/presentation/widgets/movie_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<NowPlayingBloc>()..add(const FetchNowPlayingMovies(initial: true)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'IMDUMB',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Now Playing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              MovieCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
