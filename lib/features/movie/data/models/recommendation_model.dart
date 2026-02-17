import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imdumb/features/movie/domain/entities/recommendation.dart';

class RecommendationModel extends Recommendation {
  const RecommendationModel({
    required super.id,
    required super.movieId,
    required super.userId,
    required super.comment,
    required super.tags,
    required super.createdAt,
  });

  factory RecommendationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecommendationModel(
      id: doc.id,
      movieId: data['movieId'] as int,
      userId: data['userId'] as String,
      comment: data['comment'] as String,
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'movieId': movieId,
      'userId': userId,
      'comment': comment,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory RecommendationModel.fromEntity(Recommendation entity) {
    return RecommendationModel(
      id: entity.id,
      movieId: entity.movieId,
      userId: entity.userId,
      comment: entity.comment,
      tags: entity.tags,
      createdAt: entity.createdAt,
    );
  }
}
