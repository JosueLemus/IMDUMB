import 'package:hive/hive.dart';

import '../../domain/entities/genre.dart';

part 'genre_model.g.dart';

@HiveType(typeId: 0)
class GenreModel extends Genre {
  const GenreModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.name,
    @HiveField(2) super.bannerUrl,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'banner_url': bannerUrl};
  }
}
