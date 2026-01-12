part of 'foods_bloc.dart';

abstract class FoodsEvent extends Equatable {
  const FoodsEvent();

  @override
  List<Object> get props => [];
}

class GetFoodsEvent extends FoodsEvent {
  final String category;

  const GetFoodsEvent(this.category);

  @override
  List<Object> get props => [category];
}
