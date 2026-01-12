import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/utils/failures.dart';

/// Parameters for adding item to cart
class AddToCartParams extends Equatable {
  final FoodEntity food;
  final List<AddonEntity> addons;
  final int quantity;

  const AddToCartParams({
    required this.food,
    required this.addons,
    required this.quantity,
  });

  @override
  List<Object?> get props => [food, addons, quantity];
}

/// Use case for adding item to cart
class AddToCart {
  final Repository _repository;

  AddToCart(this._repository);

  /// Calls the repository to add item to cart
  /// Returns [Either] with [FirestoreFailure] on failure or [Unit] on success
  Future<Either<FirestoreFailure, Unit>> call(AddToCartParams params) async {
    return await _repository.addToCart(
      params.food,
      params.addons,
      params.quantity,
    );
  }
}
