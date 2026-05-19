import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_recommended_products.dart';

part 'recommended_event.dart';
part 'recommended_state.dart';

class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  RecommendedBloc(this._getRecommendedProducts)
      : super(const RecommendedState()) {
    on<RecommendedRequested>(_onRequested);
  }

  final GetRecommendedProducts _getRecommendedProducts;

  Future<void> _onRequested(
    RecommendedRequested event,
    Emitter<RecommendedState> emit,
  ) async {
    emit(state.copyWith(status: RecommendedStatus.loading, clearError: true));
    try {
      final list = await _getRecommendedProducts();
      emit(state.copyWith(status: RecommendedStatus.success, products: list));
    } catch (e) {
      emit(state.copyWith(
        status: RecommendedStatus.failure,
        errorMessage: messageOf(e),
      ));
    }
  }
}
