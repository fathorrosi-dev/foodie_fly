import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/domain/usecases/get_foods.dart';

part 'foods_event.dart';
part 'foods_state.dart';

class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  final GetFoods _getFoods;

  FoodsBloc(this._getFoods) : super(FoodsInitial()) {
    on<GetFoodsEvent>(_getFoodsEvent);
  }

  Future<void> _getFoodsEvent(
    GetFoodsEvent event,
    Emitter<FoodsState> emit,
  ) async {
    emit(FoodsLoading());
    final result = await _getFoods.execute(event.category);

    result.fold(
      (failure) => emit(FoodsError(failure.message)),
      (foods) => emit(FoodLoaded(foods)),
    );
  }
}
