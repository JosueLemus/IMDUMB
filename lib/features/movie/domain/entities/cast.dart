import 'package:equatable/equatable.dart';

class Cast extends Equatable {
  final int id;
  final String name;
  final String character;
  final String profilePath;
  final int order;

  const Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
    required this.order,
  });

  String get fullProfilePath => profilePath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}
