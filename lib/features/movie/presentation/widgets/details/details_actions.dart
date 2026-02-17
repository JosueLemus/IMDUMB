import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/user_recommendations_cubit.dart';
import 'package:imdumb/features/movie/presentation/widgets/details/recommend_bottom_sheet.dart';

class DetailsActions extends StatelessWidget {
  final Movie movie;

  const DetailsActions({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return _DetailsActionsContent(movie: movie);
  }
}

class _DetailsActionsContent extends StatelessWidget {
  final Movie movie;

  const _DetailsActionsContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<UserRecommendationsCubit, UserRecommendationsState>(
      builder: (context, state) {
        final recommendation = state.getRecommendationForMovie(movie.id);
        final isRecommended = recommendation != null;

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showRecommendSheet(context),
                icon: Icon(
                  isRecommended
                      ? Icons.check_circle_rounded
                      : Icons.thumb_up_rounded,
                  size: 24,
                ),
                label: Text(
                  isRecommended ? 'Recommended' : 'Recommend',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecommended
                      ? colorScheme.primaryContainer
                      : colorScheme.primary,
                  foregroundColor: isRecommended
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onPrimary,
                  elevation: isRecommended ? 0 : 8,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.4),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            if (isRecommended) ...[
              const SizedBox(width: 12),
              _actionButton(
                context,
                icon: Icons.delete_outline_rounded,
                color: colorScheme.error,
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
            const SizedBox(width: 12),
            _actionButton(
              context,
              icon: Icons.favorite_rounded,
              color: colorScheme.onSurfaceVariant,
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  void _showRecommendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<UserRecommendationsCubit>(),
        child: RecommendBottomSheet(movie: movie),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<UserRecommendationsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Recommendation'),
        content: const Text(
          'Are you sure you want to remove your recommendation for this movie?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.removeRecommendation(movie.id);
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
