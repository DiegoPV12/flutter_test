part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.products = const [],
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<Product> products;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Product>? products,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      products: products ?? this.products,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, query, products, errorMessage];
}
