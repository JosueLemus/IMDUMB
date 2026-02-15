import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/nav_wrapper.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

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
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Saved Page'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Profile Page'))),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
