import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imdumb/features/movie/data/models/recommendation_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<void> recommendMovie(RecommendationModel recommendation);
  Future<void> deleteRecommendation(String id);
  Future<RecommendationModel?> getRecommendationForMovie(
    int movieId,
    String userId,
  );
}

class RecommendationRemoteDataSourceImpl
    implements RecommendationRemoteDataSource {
  final FirebaseFirestore firestore;

  RecommendationRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> recommendMovie(RecommendationModel recommendation) async {
    final docRef = recommendation.id.isEmpty
        ? firestore.collection('recommendations').doc()
        : firestore.collection('recommendations').doc(recommendation.id);
    await docRef.set(recommendation.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteRecommendation(String id) async {
    await firestore.collection('recommendations').doc(id).delete();
  }

  @override
  Future<RecommendationModel?> getRecommendationForMovie(
    int movieId,
    String userId,
  ) async {
    final snapshot = await firestore
        .collection('recommendations')
        .where('movieId', isEqualTo: movieId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return RecommendationModel.fromFirestore(snapshot.docs.first);
    }
    return null;
  }
}
