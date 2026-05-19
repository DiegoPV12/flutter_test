part of 'recommended_bloc.dart';

enum RecommendedStatus { initial, loading, success, failure }

class RecommendedState extends Equatable {
  const RecommendedState({
    this.status = RecommendedStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final RecommendedStatus status;
  final List<Product> products;
  final String? errorMessage;

  RecommendedState copyWith({
    RecommendedStatus? status,
    List<Product>? products,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecommendedState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
