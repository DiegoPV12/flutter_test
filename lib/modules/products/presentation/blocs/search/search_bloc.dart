import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
    on<SearchCleared>(_onCleared);
  }

  final ProductRepository _repository;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }
    emit(state.copyWith(
      status: SearchStatus.loading,
      query: query,
      clearError: true,
    ));
    try {
      final results = await _repository.searchProducts(query);
      emit(state.copyWith(
        status: SearchStatus.success,
        products: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: messageOf(e),
      ));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }
}

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events
      .debounceTime(duration)
      .switchMap(mapper);
}

extension<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    Timer? timer;
    final controller = StreamController<T>();
    final sub = listen(
      (event) {
        timer?.cancel();
        timer = Timer(duration, () => controller.add(event));
      },
      onError: controller.addError,
      onDone: () {
        timer?.cancel();
        controller.close();
      },
    );
    controller.onCancel = () {
      timer?.cancel();
      sub.cancel();
    };
    return controller.stream;
  }

  Stream<R> switchMap<R>(Stream<R> Function(T) mapper) {
    StreamSubscription<R>? inner;
    final controller = StreamController<R>();
    final outer = listen(
      (event) {
        inner?.cancel();
        inner = mapper(event).listen(
          controller.add,
          onError: controller.addError,
        );
      },
      onError: controller.addError,
      onDone: () async {
        await inner?.cancel();
        await controller.close();
      },
    );
    controller.onCancel = () async {
      await inner?.cancel();
      await outer.cancel();
    };
    return controller.stream;
  }
}
