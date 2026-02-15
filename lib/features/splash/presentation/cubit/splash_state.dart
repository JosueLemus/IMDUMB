import 'package:equatable/equatable.dart';

enum SplashStatus { initial, loading, success }

class SplashState extends Equatable {
  const SplashState({this.status = SplashStatus.initial});

  final SplashStatus status;

  @override
  List<Object?> get props => [status];

  SplashState copyWith({SplashStatus? status}) {
    return SplashState(status: status ?? this.status);
  }
}
