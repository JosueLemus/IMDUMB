import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdumb/core/di/injection_container.dart';
import 'package:imdumb/core/services/remote_config_service.dart';
import 'package:imdumb/features/splash/presentation/pages/splash_page.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/nav_wrapper.dart';
import '../../features/movie/domain/entities/movie.dart';
import '../../features/movie/presentation/pages/genre_movies_page.dart';
import '../../features/movie/presentation/pages/movie_details_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

abstract class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/movie-details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final movie = state.extra as Movie;
          return MovieDetailsPage(movie: movie);
        },
      ),
      GoRoute(
        path: '/genre-movies',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return GenreMoviesPage(
            genreId: extra['id'] as int,
            genreName: extra['name'] as String,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Explore Page'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) => Scaffold(
                  body: Center(
                    child: Text(
                      sl<RemoteConfigService>().getHelloText(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
