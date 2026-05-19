part of 'recommended_bloc.dart';

sealed class RecommendedEvent extends Equatable {
  const RecommendedEvent();
  @override
  List<Object?> get props => [];
}

class RecommendedRequested extends RecommendedEvent {
  const RecommendedRequested();
}
