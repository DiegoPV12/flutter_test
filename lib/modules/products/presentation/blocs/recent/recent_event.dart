part of 'recent_bloc.dart';

sealed class RecentEvent extends Equatable {
  const RecentEvent();
  @override
  List<Object?> get props => [];
}

class RecentRequested extends RecentEvent {
  const RecentRequested();
}
