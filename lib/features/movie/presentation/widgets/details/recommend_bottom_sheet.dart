import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdumb/core/theme/app_typography.dart';
import 'package:imdumb/features/movie/domain/entities/movie.dart';
import 'package:imdumb/features/movie/presentation/bloc/user_recommendations_cubit.dart';

class RecommendBottomSheet extends StatefulWidget {
  final Movie movie;

  const RecommendBottomSheet({super.key, required this.movie});

  @override
  State<RecommendBottomSheet> createState() => _RecommendBottomSheetState();
}

class _RecommendBottomSheetState extends State<RecommendBottomSheet> {
  final _commentController = TextEditingController();
  final List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Must Watch',
    'Mind Blown',
    'Great Acting',
    'Epic Story',
    'Visual Masterpiece',
  ];

  @override
  void initState() {
    super.initState();
    final currentRecommendation = context
        .read<UserRecommendationsCubit>()
        .state
        .getRecommendationForMovie(widget.movie.id);
    if (currentRecommendation != null) {
      _commentController.text = currentRecommendation.comment;
      _selectedTags.addAll(currentRecommendation.tags);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final year = widget.movie.releaseDate.split('-').first;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommend Movie',
                      style: AppTypography.displayLarge.copyWith(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.movie.fullPosterPath,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movie.title,
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$year  •  ${widget.movie.voteAverage.toStringAsFixed(1)} Score',
                            style: AppTypography.movieMetaInfo,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Why do you recommend this? (Optional)',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  maxLength: 280,
                  decoration: InputDecoration(
                    hintText:
                        'Add a comment... e.g. The plot twist at the end is insane!',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.outline,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Tags',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => _toggleTag(tag),
                      selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                      checkmarkColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                BlocConsumer<
                  UserRecommendationsCubit,
                  UserRecommendationsState
                >(
                  listener: (context, state) {
                    if (state.status == UserRecommendationsStatus.success) {
                      Navigator.pop(context);
                    }
                    if (state.status == UserRecommendationsStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Error'),
                          backgroundColor: colorScheme.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed:
                          state.status == UserRecommendationsStatus.submitting
                          ? null
                          : () {
                              context
                                  .read<UserRecommendationsCubit>()
                                  .submitRecommendation(
                                    movieId: widget.movie.id,
                                    comment: _commentController.text,
                                    tags: _selectedTags,
                                  );
                            },
                      icon: state.status == UserRecommendationsStatus.submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        state.getRecommendationForMovie(widget.movie.id) != null
                            ? 'Update Recommendation'
                            : 'Confirm Recommendation',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
