part of 'foods_bloc.dart';

abstract class FoodsState extends Equatable {
  const FoodsState();

  @override
  List<Object> get props => [];
}

class FoodsInitial extends FoodsState {}

class FoodsLoading extends FoodsState {}

class FoodLoaded extends FoodsState {
  final List<FoodEntity> foods;

  const FoodLoaded(this.foods);

  @override
  List<Object> get props => [foods];
}

class FoodsError extends FoodsState {
  final String message;

  const FoodsError(this.message);

  @override
  List<Object> get props => [message];
}
