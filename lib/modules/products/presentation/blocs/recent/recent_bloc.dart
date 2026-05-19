import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  RecentBloc(this._repository) : super(const RecentState()) {
    on<RecentRequested>(_onRequested);
  }

  final ProductRepository _repository;

  Future<void> _onRequested(
    RecentRequested event,
    Emitter<RecentState> emit,
  ) async {
    emit(state.copyWith(status: RecentStatus.loading, clearError: true));
    try {
      final list = await _repository.getRecentProducts();
      emit(state.copyWith(status: RecentStatus.success, products: list));
    } catch (e) {
      emit(state.copyWith(
        status: RecentStatus.failure,
        errorMessage: messageOf(e),
      ));
    }
  }
}
