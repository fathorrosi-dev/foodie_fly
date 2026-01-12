import 'package:dartz/dartz.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

class GetFoods {
  final Repository _repository;

  GetFoods(this._repository);

  Future<Either<FirestoreFailure, List<FoodEntity>>> execute(
    String category,
  ) async {
    return await _repository.getFoods(category);
  }
}
