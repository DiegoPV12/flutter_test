import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(this._repository) : super(const DetailState()) {
    on<DetailRequested>(_onRequested);
  }

  final ProductRepository _repository;

  Future<void> _onRequested(
    DetailRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading, clearError: true));
    try {
      final product = await _repository.getProductById(event.productId);
      await _repository.saveRecentProduct(product);
      emit(state.copyWith(status: DetailStatus.success, product: product));
    } catch (e) {
      emit(state.copyWith(
        status: DetailStatus.failure,
        errorMessage: messageOf(e),
      ));
    }
  }
}
