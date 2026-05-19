part of 'detail_bloc.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class DetailRequested extends DetailEvent {
  const DetailRequested(this.productId);
  final int productId;
  @override
  List<Object?> get props => [productId];
}
