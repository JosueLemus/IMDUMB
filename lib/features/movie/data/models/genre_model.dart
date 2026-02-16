import 'package:hive/hive.dart';

import '../../domain/entities/genre.dart';

part 'genre_model.g.dart';

@HiveType(typeId: 0)
class GenreModel extends Genre {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String? bannerUrl;

  const GenreModel({required this.id, required this.name, this.bannerUrl})
    : super(id: id, name: name, bannerUrl: bannerUrl);

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'banner_url': bannerUrl};
  }
}
