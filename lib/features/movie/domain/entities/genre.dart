import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;
  final String? bannerUrl;

  const Genre({required this.id, required this.name, this.bannerUrl});

  Genre copyWith({int? id, String? name, String? bannerUrl}) {
    return Genre(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerUrl: bannerUrl ?? this.bannerUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, bannerUrl];
}
