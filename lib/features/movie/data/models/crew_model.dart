import 'package:imdumb/features/movie/domain/entities/crew.dart';

class CrewModel extends Crew {
  const CrewModel({
    required super.id,
    required super.name,
    required super.job,
    required super.department,
    required super.profilePath,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      id: json['id'],
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      department: json['department'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'department': department,
      'profile_path': profilePath,
    };
  }
}
