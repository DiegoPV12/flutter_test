part of 'recent_bloc.dart';

enum RecentStatus { initial, loading, success, failure }

class RecentState extends Equatable {
  const RecentState({
    this.status = RecentStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final RecentStatus status;
  final List<Product> products;
  final String? errorMessage;

  RecentState copyWith({
    RecentStatus? status,
    List<Product>? products,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecentState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
