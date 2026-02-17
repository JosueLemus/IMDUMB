import 'package:equatable/equatable.dart';

class Recommendation extends Equatable {
  final String id;
  final int movieId;
  final String userId;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const Recommendation({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, movieId, userId, comment, tags, createdAt];
}
