import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  final int id;
  final String name;
  final String job;
  final String department;
  final String profilePath;

  const Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    required this.profilePath,
  });

  String get fullProfilePath => profilePath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

  @override
  List<Object?> get props => [id, name, job, department, profilePath];
}
