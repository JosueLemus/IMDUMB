import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/category_banner_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(FetchHomeCategories()),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.movie_creation_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            'IMDUMB',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is HomeLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.genres.length,
                itemBuilder: (context, index) {
                  return CategoryBannerWidget(
                    genre: state.genres[index],
                    onTap: () {
                      context.push(
                        '/genre-movies',
                        extra: {
                          'id': state.genres[index].id,
                          'name': state.genres[index].name,
                        },
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
