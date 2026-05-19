part of 'detail_bloc.dart';

enum DetailStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  const DetailState({
    this.status = DetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  final DetailStatus status;
  final Product? product;
  final String? errorMessage;

  DetailState copyWith({
    DetailStatus? status,
    Product? product,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}
